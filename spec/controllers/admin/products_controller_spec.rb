require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  describe 'authorized user(admin)' do
    let(:user) { create(:user, admin: true) }
    before do
      login(user)
      get :index
    end

    describe 'GET#index' do
      let(:products) { create_list(:product, 5) }
      it 'populates an array of all products' do
        expect(assigns(:products)).to match_array(products)
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'POST#create' do
      let(:barnd) { create(:brand) }
      let(:product) do
        build(:product, title: Faker::Commerce.product_name,
                        description: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                        brand_id: barnd.id,
                        price: Faker::Commerce.price)
      end
      it 'create new product' do
        expect do
          post :create, params: { product:
                                          {
                                            title: product.title,
                                            description: product.description,
                                            brand_id: product.brand_id,
                                            price: product.price
                                          } }, format: :turbo_stream
        end.to change(Product, :count).by(1)

        %i[title description brand_id price].each do |field|
          expect(Product.first.send(field)).to eq(product.send(field))
        end
      end
      it 'does not create new product with wrong params' do
        expect do
          post :create, params: { product:
                                          {
                                            title: nil,
                                            description: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                                            brand_id: barnd.id,
                                            price: Faker::Commerce.price
                                          } }, format: :turbo_stream
        end.to change(Product, :count).by(0)
      end
    end

    describe 'PATCH#update' do
      let(:barnd) { create(:brand) }
      let(:updated_brand) { create(:brand) }
      let(:product) do
        create(:product, title: Faker::Commerce.product_name,
                         description: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                         brand_id: barnd.id,
                         price: Faker::Commerce.price)
      end
      it 'update product' do
        updated_product =
          build(:product, title: 'Updated title',
                          description: 'Updated description',
                          brand_id: updated_brand.id,
                          price: '13.00')
        patch :update, params: { id: product, product:
                                          {
                                            title: updated_product.title,
                                            description: updated_product.description,
                                            brand_id: updated_product.brand_id,
                                            price: updated_product.price
                                          } }, format: :turbo_stream
        %i[title description brand_id price].each do |field|
          expect(Product.first.send(field)).to eq(updated_product.send(field))
        end
      end
      it 'does not create update product with wrong params' do
        updated_product =
          build(:product, title: nil,
                          description: 'Updated description',
                          brand_id: updated_brand.id,
                          price: '13.00')
        patch :update, params: { id: product, product:
                                          {
                                            title: updated_product.title,
                                            description: updated_product.description,
                                            brand_id: updated_product.brand_id,
                                            price: updated_product.price
                                          } }, format: :turbo_stream
        %i[title description brand_id price].each do |field|
          expect(Product.first.send(field)).to_not eq(updated_product.send(field))
        end
      end
    end
  end
end
