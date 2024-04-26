FactoryBot.define do
  factory :product do

    association :brand, factory: :brand
    sequence(:title) { |n| "MyString_Title_#{n}" }
    description { "MyText_description" }

    trait :invalid do
      title { nil }
    end
  end
end
