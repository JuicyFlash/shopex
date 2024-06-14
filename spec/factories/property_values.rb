FactoryBot.define do
  factory :property_value do
    association :property, factory: :property

    value { Faker::Lorem.word }
  end
end
