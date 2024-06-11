Rails.application.routes.draw do
  resources :products, only: %i[index show]
  root 'products#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
