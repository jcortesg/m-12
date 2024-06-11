require 'faker'

# Clear existing products
Product.delete_all

# Generate 12 random products
12.times do
  Product.create!(
    name: Faker::Commerce.product_name,
    price: Faker::Commerce.price(range: 0..100.0),
    url: 'https://placebear.com/300/300',
    stock: Faker::Number.between(from: 0, to: 100)
  )
end
