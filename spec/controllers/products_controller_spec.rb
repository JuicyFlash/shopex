require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    let(:products) { create_list(:product, 5) }
    before { get :index }

    it 'populates an array of all products' do
      expect(assigns(:products)).to match_array(products)
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
  end
  describe 'GET #show' do
    let(:product) { create(:product) }
    before { get :show, params: { id: product.id } }

    it 'populates selected product' do
      expect(assigns(:product)).to eq(product)
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end
end
