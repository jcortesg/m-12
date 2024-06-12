class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :ensure_valid_quantity
  before_validation :set_price
  before_destroy :return_stock

  after_destroy :adjust_order_totals
  after_save :adjust_stock
  after_save :adjust_order_totals

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  private

  def set_price
    self.price = product.price * quantity
  end

  def ensure_valid_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  def return_stock
    product.stock += quantity
    product.save!
  end

  def adjust_stock
    return unless saved_changes?

    previous_quantity = saved_changes[:quantity][0]
    difference = quantity - previous_quantity
    product.stock -= difference
    product.save!
  end

  def adjust_order_totals
    order.calcule_totals
  end
end
