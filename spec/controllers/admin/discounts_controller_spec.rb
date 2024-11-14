require 'rails_helper'

RSpec.describe Admin::DiscountsController, type: :controller do
  describe 'authorized user(admin)' do
    let(:user) { create(:user, admin: true) }
    let(:discounts) { create_list(:discount, 5) }

    before do
      login(user)
      get :index
    end
    describe 'GET#index' do
      it 'populates an array of all orders' do
        expect(assigns(:discounts)).to match_array(discounts)
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'POST#create' do
      let(:discount) do
        build(:discount, active: true, target: 'catalog')
      end
      let(:discount_condition) do
        build(:discount_condition, condition_type: :discount_by_product_id, value: '1233')
      end

      it 'create new discount' do
        expect do
          post :create, params: { discount:
                                    {
                                      description: discount.description,
                                      value: discount.value,
                                      active: discount.active,
                                      target: discount.target
                                    } }, format: :turbo_stream
        end.to change(Discount, :count).by(1)

        %i[description value active target].each do |field|
          expect(Discount.first.send(field)).to eq(discount.send(field))
        end
      end
      it 'does not create new property with wrong params' do
        expect do
          post :create, params: { discount:
                                    {
                                      description: nil,
                                      value: discount.value,
                                      active: discount.active,
                                      target: discount.target
                                    } }, format: :turbo_stream
        end.to change(Discount, :count).by(0)
      end
      it 'create new property and nested values' do
        expect do
          post :create, params: { discount:
                                    {
                                      description: discount.description,
                                      value: discount.value,
                                      active: discount.active,
                                      target: discount.target,
                                      conditions_attributes: { "1": { condition_type: discount_condition.condition_type, value: discount_condition.value, _destroy: '0' } }
                                    } }, format: :turbo_stream
        end.to change(Discount, :count).by(1) && change(DiscountCondition, :count).by(1)
      end
    end

    describe 'PATCH#update' do
      let!(:discount) { create(:discount, active: true, target: 'catalog') }
      let!(:discount_condition) { create(:discount_condition, discount: discount, condition_type: :discount_by_product_id, value: '1233') }

      it 'update discount' do
        patch :update, params: { id: discount, discount: {
          description: "#{discount.description}_updated",
          active: false
        } }, format: :turbo_stream

        expect(Discount.count).to eq 1
        expect(Discount.first.description).to eq "#{discount.description}_updated"
        expect(Discount.first.active).to eq false
      end
      it  'update nested value' do
        patch :update, params: {id: discount.id, discount:
                                                  {
                                                    description: discount.description,
                                                    value: discount.value,
                                                    active: discount.active,
                                                    target: discount.target,
                                                    conditions_attributes: { "1": { id: discount_condition.id, condition_type: discount_condition.condition_type, value: 'updated', _destroy: '0' } }
                                                  } }, format: :turbo_stream
        expect(DiscountCondition.first.value).to eq 'updated'
      end
    end
  end
end
