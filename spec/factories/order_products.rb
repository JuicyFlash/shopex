FactoryBot.define do
  factory :order_product do
    association :order, factory: :order
    association :product, factory: :product
  end
end
