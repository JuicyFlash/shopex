FactoryBot.define do
  factory :product do
    association :brand, factory: :brand
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 3, supplemental: true) }
    price { Faker::Commerce.price }

    trait :invalid do
      title { nil }
    end
  end
end
