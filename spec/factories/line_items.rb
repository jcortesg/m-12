FactoryBot.define do
  factory :line_item do
    order
    product
    quantity { Faker::Number.between(from: 1, to: 10) }
    price { product.price * quantity }

    before(:create) do |line_item|
      line_item.price = line_item.product.price * line_item.quantity
    end
  end
end
