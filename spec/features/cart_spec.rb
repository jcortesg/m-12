require 'rails_helper'

RSpec.feature 'Agregar producto al carrito', type: :feature do
  scenario 'Usuario agrega un producto al carrito' do
    # Crear un producto
    product = FactoryBot.create(:product)

    visit products_path(product)

    click_button 'Agregar al carrito'

    expect(page).to have_content product.name
    expect(page).to have_content product.price
  end
end
