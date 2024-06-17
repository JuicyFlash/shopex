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
      it 'populates only 12 elemnts of products (pagy)' do
        create_list(:product, 24)
        expect(assigns(:products).size).to eq 12
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'POST#create' do
      let(:property) { create(:property) }
      let(:prop_values) { create_list(:property_value, 3, property:) }
      let(:brand) { create(:brand) }
      let(:product) { build(:product, brand:) }

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
      it 'create new product with nested properties values' do
        expect do
          post :create, params: { product:
                                          {
                                            title: product.title,
                                            description: product.description,
                                            brand_id: product.brand_id,
                                            price: product.price,
                                            product_property_attributes: { "1": { property_id: property.id,
                                                                                  property_value_id: prop_values[0].id },
                                                                           "2": { property_id: property.id,
                                                                                  property_value_id: prop_values[1].id },
                                                                           "3": { property_id: property.id,
                                                                                  property_value_id: prop_values[2].id } }
                                          } }, format: :turbo_stream
        end.to change(Product, :count).by(1) && change(ProductProperty, :count).by(3)

        expect(Product.first.product_property.pluck(:property_value_id)).to match_array(prop_values.pluck(:id))
      end
      it 'does not create new product with wrong params' do
        expect do
          post :create, params: { product:
                                          {
                                            title: nil,
                                            description: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                                            brand_id: brand.id,
                                            price: Faker::Commerce.price
                                          } }, format: :turbo_stream
        end.to change(Product, :count).by(0)
      end
    end

    describe 'PATCH#update' do
      let(:property) { create(:property) }
      let(:prop_values) { create_list(:property_value, 3, property:) }
      let(:barnd) { create(:brand) }
      let(:updated_brand) { create(:brand) }
      let(:product) { create(:product) }

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
      it 'update(delete) nested properties values' do
        prop_values.each do |value|
          create(:product_property, product:, property:, property_value: value)
        end
        expect do
          patch :update, params: { id: product, product:
                                            {
                                              title: product.title,
                                              description: product.description,
                                              brand_id: product.brand_id,
                                              price: product.price,
                                              product_property_attributes: { "1": { property_id: property.id,
                                                                                    property_value_id: prop_values[0].id },
                                                                             "2": { property_id: property.id,
                                                                                    property_value_id: prop_values[1].id },
                                                                             "3": { property_id: property.id,
                                                                                    property_value_id: -1 * prop_values[2].id } }
                                            } }, format: :turbo_stream
        end.to change(ProductProperty, :count).by(-1)

        expect(Product.first.product_property.pluck(:property_value_id)).to match_array(prop_values[0..1].pluck(:id))
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
