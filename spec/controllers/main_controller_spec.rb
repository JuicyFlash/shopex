require 'rails_helper'

RSpec.describe MainController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 9) }

    before { get :index }
    it 'populates an array of recommended_products' do
      expect(assigns(:recommended_products)).to match_array(products)
    end
    it 'populates an array of top_ordered_products' do
      expect(assigns(:top_ordered_products)).to match_array(products)
    end
    it 'populates an array of top_products' do
      expect(assigns(:top_products)).to match_array(products)
    end
  end
end
