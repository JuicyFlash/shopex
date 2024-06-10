FactoryBot.define do
  factory :product_property do
    association :property, factory: :property
    association :product, factory: :property
    association :property_value, factory: :property_value
  end
end
