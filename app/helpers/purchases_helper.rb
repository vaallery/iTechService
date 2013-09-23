module PurchasesHelper

  def purchase_row_class(purchase)
    case purchase.status
      when 0 then 'info'
      when 1 then 'success'
      when 2 then 'error'
    end
  end

  def purchase_status(purchase)
    t "purchases.statuses.#{purchase.status_s}"
  end

end
