FactoryBot.define do
  factory :discount_condition do
    association :discount, factory: :discount
  end
end
