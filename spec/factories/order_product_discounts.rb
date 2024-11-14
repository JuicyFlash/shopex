FactoryBot.define do
  factory :order_product_discount do
    association :order_product, factory: :order_product
  end
end
