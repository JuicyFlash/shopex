FactoryBot.define do
  factory :discount do
    description { Faker::Lorem.sentence(word_count: 5) }
    value { Faker::Number.between(from: 1, to: 99) }
  end
end
