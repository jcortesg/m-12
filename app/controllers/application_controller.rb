class ApplicationController < ActionController::Base
  before_action :set_guest_token
  helper_method :current_order
  helper_method :current_user

  def current_order
    return @current_order if @current_order

    token = cookies.signed[:guest_token]
    @current_order = Order.find_order_by_token_or_user(token, current_user)
    if @current_order.nil? || @current_order.completed?
      @current_order = Order.create!(token:, client_id: current_user&.id)
    end
    @current_order
  end

  private

  def current_user
    return @current_user if @current_user

    @current_user = Client.find_by(id: cookies.signed[:user])
  end

  def set_current_user(client)
    cookies.permanent.signed[:user] = client.id
    @current_user = client
  end

  def set_guest_token
    return if cookies.signed[:guest_token].present?

    cookies.permanent.signed[:guest_token] = {
      value: SecureRandom.urlsafe_base64(nil, false),
      httponly: true
    }
  end
end
