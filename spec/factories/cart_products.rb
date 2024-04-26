# frozen_string_literal: true

FactoryBot.define do
  factory :cart_product do
    association :product, factory: :product
    association :cart, factory: :cart
  end
end
