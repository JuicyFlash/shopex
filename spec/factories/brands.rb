FactoryBot.define do
  factory :brand do
    title { Faker::Commerce.brand }
  end
end
