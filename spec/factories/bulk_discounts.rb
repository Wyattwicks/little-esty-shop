FactoryBot.define do
  factory :random_bulk_discount, class: BulkDiscount do
    discount { rand(1..100) }
    quantity_threshold { rand(0..20) }
    association :merchant, factory: :random_merchant
  end
end
