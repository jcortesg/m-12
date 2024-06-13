class OrdersController < ApplicationController
  before_action :set_order, only: %i[update destroy show]
  before_action :set_user, only: [:index]
  before_action :find_client, only: [:update]

  def index
    @orders = @user.orders.complete
  end

  def show
  end

  def update
    redirect_to cart_path if @order.client.nil?
    if @order.update({ state: 'completed', completed_at: Time.zone.now })
      cookies.signed[:guest_token] = nil
      redirect_to orders_path, notice: 'La orden fue actualizada correctamente.'
    else
      redirect_to cart_path, alert: 'Hubo un error al actualizar la orden.'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, notice: 'La orden fue eliminada correctamente.'
  end

  private

  def find_client
    @order.client = current_user && return if current_user

    return unless params[:order][:client_attributes].present?

    @order.client ||= Client.find_or_create_by(email: params[:order][:client_attributes][:email])
    set_current_user(@order.client)
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def order_params
    params.require(:order).permit(
      client_attributes: %i[nombre email]
    )
  end
end
