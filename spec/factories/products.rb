FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 0..100.0) }
    stock { Faker::Number.between(from: 1, to: 10) }
    url { Faker::Internet.url }
  end
end
