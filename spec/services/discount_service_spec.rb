# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartService do
  let!(:products) { create_list(:product, 5) }
  let!(:discount_products) { create(:discount, target: 'all', value: 10, active: true) }
  let!(:discount_products_condition) { create(:discount_condition, discount: discount_products, condition_type:  :discount_by_product_id, value: Product.all.pluck(:id).join(',')) }
  let!(:discount_brands) { create(:discount, target: 'all', value: 10, active: true) }
  let!(:discount_brands_condition) { create(:discount_condition, discount: discount_brands, condition_type:  :discount_by_product_brand, value: Product.first.brand.id) }
  let!(:discount_service){ DiscountService.new }

  it 'contain available discounts' do
    discount_service.configure
    expect(discount_service.available_discounts[0][:discount_record]).to eq(discount_products)
    expect(discount_service.available_discounts[1][:discount_record]).to eq(discount_brands)
  end
  it 'contain conditions for discounts' do
    discount_service.configure
    expect(discount_service.available_discounts[0][:discount_conditions][0]).to be_instance_of(ConditionByProductId)
    expect(discount_service.available_discounts[1][:discount_conditions][0]).to be_instance_of(ConditionByProductBrand)
  end
end
