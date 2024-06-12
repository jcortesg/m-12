FactoryBot.define do
  factory :order do
    item_total { 0 }
    total { 0 }
    state { 'cart' }
    completed_at { nil }
    item_count { 0 }
    token { SecureRandom.hex(10) }
  end
end
