class Sale < ActiveRecord::Base
  include Document

  scope :sold_at, lambda { |period| where(date: period) }
  scope :posted, where(status: 1)
  scope :deleted, where(status: 2)
  scope :unposted, where('status <> ?', 1)
  scope :returning, where(is_return: true)
  scope :selling, where(is_return: false)

  belongs_to :user, inverse_of: :sales
  belongs_to :client, inverse_of: :sales
  belongs_to :store
  belongs_to :cash_shift, inverse_of: :sales
  has_many :sale_items, inverse_of: :sale, dependent: :destroy
  has_many :items, through: :sale_items
  has_many :payments, inverse_of: :sale, dependent: :destroy
  has_one :device, inverse_of: :sale
  accepts_nested_attributes_for :sale_items, allow_destroy: true, reject_if: lambda{|a| a[:id].blank? and a[:item_id].blank?}
  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: lambda{|a| a[:value].blank?}

  delegate :name, :short_name, :full_name, :fio_short, to: :user, prefix: true, allow_nil: true
  delegate :name, :short_name, :full_name, :category, :category_s, to: :client, prefix: true, allow_nil: true
  delegate :name, to: :payment_type, prefix: true, allow_nil: true
  delegate :name, to: :store, prefix: true
  delegate :device_tasks, :repair_parts, to: :device, allow_nil: true

  attr_accessible :date, :client_id, :user_id, :store_id, :sale_items_attributes, :is_return, :payment_ids, :payments_attributes, :total_discount
  validates_presence_of :user, :store, :date, :status, :cash_shift
  validates_inclusion_of :status, in: Document::STATUSES.keys
  validates_associated :payments
  before_validation :set_user_and_cash_shift

  after_initialize do
    self.user_id ||= User.current.try(:id)
    self.date ||= DateTime.current
    self.status ||= 0
    self.is_return ||= false
    self.store_id ||= User.current.try(:retail_store).try(:id)
  end

  def self.search(params)
    sales = Sale.scoped

    if (status_q = params[:status]).present?
      sales = sales.where(status: status_q)
    end

    if (is_return_q = params[:is_return]).present?
      sales = sales.where(is_return: is_return_q)
    end

    unless (start_date = params[:start_date]).blank?
      sales = sales.where('sold_at >= ?', start_date)
    end

    unless (end_date = params[:end_date]).blank?
      sales = sales.where('sold_at <= ?', end_date)
    end

    if (search = params[:search]).present?
      sales = sales.where id: search
    end

    if (client_q = params[:client]).present?
      sales = sales.joins(:client).where 'LOWER(clients.name) LIKE :q OR LOWER(clients.surname) LIKE :q OR clients.phone_number LIKE :q OR clients.full_phone_number LIKE :q OR LOWER(clients.card_number) LIKE :q', q: "%#{client_q.mb_chars.downcase.to_s}%"
    end

    sales
  end

  def total_discount
    sale_items.sum :discount
  end

  def total_discount=(new_value)
    if (new_value = new_value.to_f) > 0
      item_discount = new_value.fdiv(sale_items.count)
      sale_items.each{|si| si.discount = item_discount}
    end
  end

  def kind
    is_return ? 'return' : 'sale'
  end

  def client_presentation
    client.present? ? client.presentation : '-'
  end

  def post
    if is_valid_for_posting?
      transaction do
        sale_items.each do |sale_item|
          unless sale_item.is_service
            if is_return?
              sale_item.item.add_to_store store, sale_item.quantity
            else
              sale_item.item.remove_from_store store, sale_item.quantity
            end
          end
        end
        payments.gift_certificates.each do |payment|
          if is_return?
            payment.gift_certificate.issue
          else
            payment.gift_certificate.consume = payment.value
          end
        end
        update_attribute :status, 1
        update_attribute :date, DateTime.current
      end
    else
      false
    end
  end

  def build_return
    new_sale = Sale.new is_return: true, client_id: self.client_id, store_id: self.store_id
    self.sale_items.each do |sale_item|
      new_sale.sale_items.build item_id: sale_item.item_id, quantity: sale_item.quantity, price: sale_item.price, discount: sale_item.discount
    end
    self.payments.each do |payment|
      new_sale.payments.build value: payment.value, kind: payment.kind, bank_id: payment.bank_id, device_number: payment.device_name, client_info: payment.client_info, appraiser: payment.appraiser, device_logout: true
    end
    new_sale
  end

  def attach_gift_certificate(number)
    if (payment = payments.gift_certificates.first).present?
      if payment.create_gift_certificate number: number, nominal: payment.value
        payment.save
      else
        errors[:base] << t('sales.errors.create_gift_certificate_fail')
      end
    else
      errors[:base] << t('sales.errors.no_payment_with_certificate')
    end
  end

  def needs_gift_certificate?
    payments.gift_certificates.where(gift_certificate_id: nil).any?
  end

  def cancel
    update_attribute :status, 2
  end

  def total_sum
    calculation_amount + total_discount
  end

  def calculation_amount(signed=false)
    res = sale_items.all.sum &:sum
    (signed and is_return) ? -1*res : res
  end

  def payments_sum
    payments.sum :value
  end

  def add_payment(params)
    payments.create params
  end

  def is_postable?
    persisted? and is_new? and (is_return and sale_items.any? or calculation_amount == payments_sum)
  end

  private

  def set_user_and_cash_shift
    self.user_id ||= User.current.try(:id)
    self.cash_shift_id ||= User.current.current_cash_shift
  end

  def is_valid_for_posting?
    is_valid = true
    if is_new?
      sale_items.each do |sale_item|
        unless sale_item.is_service
          store_item = sale_item.store_item(store)
          if is_return?
            if sale_item.feature_accounting and store_item.present?
              self.errors[:base] << I18n.t('sales.errors.item_already_present', item: store_item.name, store: store_item.store_name)
              is_valid = false
            end
          else
            if !store_item.present? or store_item.quantity < sale_item.quantity
              self.errors[:base] << I18n.t('sales.errors.out_of_stock')
              is_valid = false
            end
          end
        end
      end
      payments.gift_certificates.each do |payment|
        if is_return?
          if payment.gift_certificate.nil?
            self.errors[:base] << I18n.t('payments.errors.no_gift_certificate')
            is_valid = false
          end
          if payment.gift_certificate.balance < payment.value
            self.errors[:base] << I18n.t('gift_certificates.errors.consumption_exceeded')
            is_valid = false
          end
        end
      end
    else
      errors[:base] << I18n.t('documents.errors.cannot_be_posted')
      is_valid = false
    end
    is_valid
  end

end
