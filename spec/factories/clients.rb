FactoryBot.define do
  factory :client do
    email { Faker::Internet.email }
    nombre { Faker::Name.name }
  end
end
