Rails.application.routes.draw do
  resources :products, only: %i[index]
  resources :cart_line_items, only: %i[create destroy]

  resource :cart, only: %i[show update] do
    put 'empty'
  end

  root 'products#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
