# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SearchService do

  describe 'return products by params' do
    let!(:first_brand) { create(:brand) }
    let!(:second_brand) { create(:brand) }
    let!(:first_brand_products) { create_list(:product, 4, brand: first_brand) }
    let!(:second_brand_products) { create_list(:product, 4, brand: second_brand) }
    let!(:first_product_property) { create(:product_property, product: first_brand_products[0]) }
    let!(:second_product_property) { create(:product_property, product: second_brand_products[1],
                                            property: first_product_property.property,
                                            property_value: first_product_property.property_value) }

    it 'return products by brands params' do
      params = { :brands => [first_brand.id] }

      expect(SearchService.get_products_by_params(params)).to match_array(first_brand_products)
    end

    it 'return products by properties values params' do
      params = { :properties => { first_product_property.property.id => [first_product_property.property_value.id],
                                  second_product_property.property.id => [second_product_property.property_value.id]} }

      expect(SearchService.get_products_by_params(params)).to match_array([first_brand_products[0], second_brand_products[1]])
    end

    it 'return products by brands and by properties values params' do
      params = { :brands => [first_brand.id],
                 :properties => { first_product_property.property.id => [first_product_property.property_value.id],
                                  second_product_property.property.id => [second_product_property.property_value.id]} }

      expect(SearchService.get_products_by_params(params)).to match_array([first_brand_products[0]])
    end

    it 'return all products if params is empty' do
      params = {}

      expect(SearchService.get_products_by_params(params)).to match_array(first_brand_products + second_brand_products)
    end
  end
end
