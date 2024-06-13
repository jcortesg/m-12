class CartsController < ApplicationController
  def show
    @order = current_order
    @order.client = Client.new if @order.client.nil?
  end
end
