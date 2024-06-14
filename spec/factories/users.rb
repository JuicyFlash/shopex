FactoryBot.define do
  factory :user do

    email { Faker::Internet.email }
    password {"1z2z3z4z5z6"}
  end
end
