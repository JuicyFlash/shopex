FactoryBot.define do
  factory :order_detail do
    association :order, factory: :order
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    house_number { Faker::Address.secondary_address }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
