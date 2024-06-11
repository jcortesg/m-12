require 'rails_helper'

RSpec.feature 'Products', type: :feature do
  scenario 'User visits the products index page' do
    products = create_list(:product, 3)
    visit products_path

    products.each do |product|
      expect(page).to have_content(product.name)
    end
  end
end
