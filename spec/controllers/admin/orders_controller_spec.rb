require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  describe 'authorized user(admin)' do
    let(:user) { create(:user, admin: true) }
    let(:orders) { create_list(:order, 10) }
    before do
      login(user)
      get :index
    end

    describe 'GET#index' do
      it 'populates an array of all orders' do
        expect(assigns(:orders)).to match_array(orders)
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end
  end
end
