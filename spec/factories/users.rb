FactoryBot.define do
  factory :user do

    sequence(:email) { |n| "MyTestEmail_#{n}@gmail.com" }
    password {"1z2z3z4z5z6"}
  end
end
