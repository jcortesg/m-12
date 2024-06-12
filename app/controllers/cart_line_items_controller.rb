class CartLineItemsController < ApplicationController
  before_action :set_order

  def create
    product = Product.find(params[:product_id])
    @cart_item = @order.line_items.find_or_initialize_by(product:)
    @cart_item.quantity += 1

    if @cart_item.save!
      redirect_to cart_path, notice: 'El producto se ha añadido al carrito correctamente.'
    else
      redirect_to products_path, alert: 'No se ha podido añadir el producto al carrito.'
    end
  end

  def destroy
    @cart_item = LineItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: 'El producto se ha eliminado del carrito correctamente.'
  end

  private

  def set_order
    @order = current_order
  end
end
