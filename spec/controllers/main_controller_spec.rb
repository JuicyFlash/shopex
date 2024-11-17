require 'rails_helper'

RSpec.describe MainController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 18) }

    before { get :index }
    it 'populates an array of recommended_products' do
      expect(assigns(:recommended_products)).to match_array(Product.last(9))
    end
    it 'populates an array of top_ordered_products' do
      expect(assigns(:top_ordered_products)).to match_array(Product.first(9))
    end
    it 'populates an array of top_products' do
      expect(assigns(:top_products)).to match_array(Product.offset(9).first(9))
    end
  end
end
