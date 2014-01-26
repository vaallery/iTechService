class Payment < ActiveRecord::Base

  KINDS = %w[cash card credit certificate trade_in]

  belongs_to :sale, inverse_of: :payments
  belongs_to :bank
  belongs_to :gift_certificate, inverse_of: :payments

  attr_accessible :value, :kind, :sale_id, :bank_id, :gift_certificate_id, :device_name, :device_number, :client_info, :appraiser

  validates_presence_of :value, :kind
  validates_presence_of :bank, if: :is_by_bank?
  validates_presence_of :gift_certificate, if: :is_gift_certificate?
  validates_presence_of :device_name, :device_number, :client_info, :appraiser, if: :is_trade_in?
  validates_acceptance_of :device_logout, if: :is_trade_in?
  # TODO gift_certificate balance validation

  def is_cash?
    kind == 'cash'
  end

  def is_credit?
    kind == 'credit'
  end

  def is_gift_certificate?
    kind == 'certificate'
  end

  def is_trade_in?
    kind == 'trade_in'
  end

  def is_by_bank?
    %W[card credit].include? kind
  end

end
