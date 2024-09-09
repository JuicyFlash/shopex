require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    let(:products) { create_list(:product, 6) }
    before { get :index }

    it 'populates an array of all products' do
      expect(assigns(:products)).to match_array(products)
    end
    it 'populates only 9 elemnts of products (pagy)' do
      create_list(:product, 12)
      expect(assigns(:products).size).to eq 9
    end
    it 'render index view' do
      expect(response).to render_template :index
    end
    describe 'filter products from params' do
      let!(:first_brand){ create(:brand) }
      let!(:second_brand){ create(:brand) }
      let!(:first_brand_products){ create_list(:product, 4, brand: first_brand) }
      let!(:second_brand_products){ create_list(:product, 4, brand: second_brand) }

      it 'populates products with brands from params' do
        create_list(:product, 10)
        get :index, params: { brands: [first_brand.id.to_s, second_brand.id] }

        expect(assigns(:products).length).to eq(8)
        expect(assigns(:products)).to match_array(first_brand_products + second_brand_products)
      end
    end
  end
  describe 'GET #show' do
    let(:product) { create(:product) }
    let(:product_properties) { create_list(:product_property, 3 , product: product) }
    before { get :show, params: { id: product.id } }

    it 'populates selected product' do
      expect(assigns(:product)).to eq(product)
    end
    it 'populates properties of selected product' do
      expect(assigns(:properties)).to eq(product.properties.distinct)
    end
    it 'populates properties values of selected product' do
      expect(assigns(:product_properties)).to eq(product.product_property)
    end
    it 'render show view' do
      expect(response).to render_template :show
    end
  end
end
