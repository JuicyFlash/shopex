# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountService do
  let!(:product_first) { create(:product, price: 1000.0) }
  let!(:product_second) { create(:product) }
  let!(:product_third) { create(:product) }
  let!(:user) { create(:user) }
  let!(:discount_by_products) {
    discount = create(:discount, target: 'catalog', value: 5, active: true)
    create(:discount_condition,
           discount: discount,
           condition_type: :discount_by_product_id,
           value: product_first.id)
    discount }
  let!(:discount_by_brand) {
    discount = create(:discount, target: 'catalog', value: 9, active: true)
    create(:discount_condition,
           discount: discount,
           condition_type: :discount_by_product_brand,
           value: product_second.brand.title)
    discount }
  let!(:discount_by_user) {
    discount = create(:discount, target: 'catalog', value: 7, active: true)
    create(:discount_condition,
           discount: discount,
           condition_type: :discount_personal,
           value: user.id)
    discount }
  let!(:discount_by_order_total_price) {
    discount = create(:discount, target: 'catalog', value: 11, active: true)
    create(:discount_condition,
           discount: discount,
           condition_type: :discount_by_order_total_price_over,
           value: 100)
    discount }
  let!(:discount_service){ DiscountService.new }

  before do
    discount_service.configure
  end
  it 'provide available discounts' do
    expect(discount_service.available_discounts[0][:discount_record]).to eq(discount_by_products)
    expect(discount_service.available_discounts[1][:discount_record]).to eq(discount_by_brand)
  end
  it 'provide conditions for discounts' do
    expect(discount_service.available_discounts[0][:discount_conditions][0]).to be_instance_of(ConditionByProductId)
    expect(discount_service.available_discounts[1][:discount_conditions][0]).to be_instance_of(ConditionByProductBrand)
  end
  it 'provide discount for product by discount_by_products' do
    discount_for_product = discount_service.discount_for(product_first, 'catalog')
    expect(discount_for_product[:discount_value]).to eq(discount_by_products.value)
  end
  it 'provide discount for product by discount_by_brand' do
    discount_for_product = discount_service.discount_for(product_second, 'catalog')
    expect(discount_for_product[:discount_value]).to eq(discount_by_brand.value)
  end
  it 'provide discount for product by discount_by_user' do
    discount_for_product = discount_service.discount_for(product_third, 'catalog', user: user )
    expect(discount_for_product[:discount_value]).to eq(discount_by_user.value)
  end
  it 'provide discount for product by discount_by_order_total_price' do
    cart = create(:cart)
    create(:cart_product, cart: cart, product: product_first)
    discount_service.configure
    discount_for_product = discount_service.discount_for(product_first, 'catalog', order: cart )
    expect(discount_for_product[:discount_value]).to eq(discount_by_order_total_price.value)
  end
  it 'provide maximum discount with similar targets' do
    condition = discount_by_products.conditions.first
    condition.value = [product_first.id, product_second.id, product_third.id].join(',')
    condition.save

    condition = discount_by_brand.conditions.first
    condition.value = [product_first.brand.title, product_second.brand.title, product_third.brand.title].join(',')
    condition.save

    discount_service.configure
    discount_for_product = discount_service.discount_for(product_first, 'catalog', user: user )
    expect(discount_for_product[:discount_value]).to eq(discount_by_brand.value)
  end
  it 'provide and summarize discounts with different targets' do
    discount_service = DiscountService.new
    condition = discount_by_products.conditions.first
    condition.value = [product_first.id, product_second.id, product_third.id].join(',')
    condition.save

    discount_by_user.target = 'personal'
    discount_by_user.save

    discount_service.configure
    discount_for_product = discount_service.discount_for(product_first, 'catalog', user: user )
    expect(discount_for_product[:discount_value]).to eq(discount_by_products.value + discount_by_user.value)
  end
end
