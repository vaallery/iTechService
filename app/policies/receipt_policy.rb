class ReceiptPolicy < ApplicationPolicy
  def new?; true; end

  def add_product?; true; end

  def print?; true; end
end
