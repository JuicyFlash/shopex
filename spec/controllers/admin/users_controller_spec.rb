require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'authorized user(admin)' do
    let(:user) { create(:user, admin: true) }
    let(:users) { create_list(:user, 10) }
    before do
      login(user)
      get :index
    end

    describe 'GET#index' do
      it 'populates an array of all users' do
        expect(assigns(:users)).to match_array(User.all)
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end
  end
end
