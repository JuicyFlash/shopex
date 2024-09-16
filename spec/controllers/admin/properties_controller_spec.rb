require 'rails_helper'

RSpec.describe Admin::PropertiesController, type: :controller do
  describe 'authorized user(admin)' do
    let(:user) { create(:user, admin: true) }
    before do
      login(user)
      get :index
    end

    describe 'GET#index' do
      let(:properties) { create_list(:property, 5) }
      it 'populates an array of all products' do
        expect(assigns(:properties)).to match_array(properties)
      end
      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'POST#create' do
      let(:property) do
        build(:property, name: Faker::Lorem.word, unique: true)
      end
      let(:values) do
        build_list(:property_value, 3)
      end

      it 'create new property' do
        expect do
          post :create, params: { property:
                                          {
                                            name: property.name,
                                            unique: 1
                                          } }, format: :turbo_stream
        end.to change(Property, :count).by(1)

        %i[name unique].each do |field|
          expect(Property.first.send(field)).to eq(property.send(field))
        end
      end
      it 'does not create new property with wrong params' do
        expect do
          post :create, params: { property:
                                          {
                                            name: nil,
                                            unique: 1
                                          } }, format: :turbo_stream
        end.to change(Property, :count).by(0)
      end
      it 'create new property and nested values' do
        expect do
          post :create, params: { property:
                                          {
                                            name: property.name,
                                            unique: 1,
                                            property_values_attributes: { "1": { value: values[0].value, _destroy: '0' },
                                                                          "2": { value: values[1].value,
                                                                                 _destroy: '0' },
                                                                          "3": { value: values[2].value,
                                                                                 _destroy: '0' } }
                                          } }, format: :turbo_stream
        end.to change(Property, :count).by(1) && change(PropertyValue, :count).by(3)

        expect(PropertyValue.all.pluck(:value)).to match_array(values.pluck(:value))
      end
      it 'create new property and reject wrong nested values' do
        expect do
          post :create, params: { property:
                                          {
                                            name: property.name,
                                            unique: 1,
                                            property_values_attributes: { "1": { value: values[0].value, _destroy: '0' },
                                                                          "2": { value: values[1].value,
                                                                                 _destroy: '0' },
                                                                          "3": { value: '',
                                                                                 _destroy: '0' } }
                                          } }, format: :turbo_stream
        end.to change(Property, :count).by(1) && change(PropertyValue, :count).by(2)

        expect(PropertyValue.all.pluck(:value)).to match_array(values[0..1].pluck(:value))
      end
    end

    describe 'PATCH#update' do
      let!(:property) { create(:property, unique: true) }
      let!(:values) { create_list(:property_value, 3, property:) }

      it 'update property' do
        patch :update, params: { id: property, property: {
          name: "#{property.name}_updated",
          unique: 0
        } }, format: :turbo_stream

        expect(Property.count).to eq 1
        expect(Property.first.name).to eq "#{property.name}_updated"
        expect(Property.first.unique).to eq false
      end
      it 'update property and update nasted values' do
        values[0].value += '_updated'
        values[1].value += '_updated'
        patch :update, params: { id: property, property: {
          name: "#{property.name}_updated",
          unique: 0,
          property_values_attributes: { "1": { value: values[0].value, _destroy: '0', id: values[0].id },
                                        "2": { value: values[1].value, _destroy: '0', id: values[1].id },
                                        "3": { value: values[2].value, _destroy: '0', id: values[2].id } }
        } }, format: :turbo_stream

        expect(Property.first.name).to eq "#{property.name}_updated"
        expect(Property.first.unique).to eq false
        expect(PropertyValue.all.pluck(:value)).to match_array(values.pluck(:value))
      end
      it 'can delete nested values' do
        patch :update, params: { id: property, property: {
          name: property.name,
          unique: 1,
          property_values_attributes: { "1": { value: values[0].value, _destroy: '0', id: values[0].id },
                                        "2": { value: values[1].value, _destroy: '0', id: values[1].id },
                                        "3": { value: values[2].value, _destroy: '1', id: values[2].id } }
        } }, format: :turbo_stream

        expect(PropertyValue.all.pluck(:value)).to_not include(values[2].value)
        expect(PropertyValue.all.pluck(:value)).to match_array(values[0..1].pluck(:value))
      end
    end

    describe 'DELETE#destroy' do
      let!(:property) { create(:property, name: Faker::Lorem.word, unique: true) }
      let!(:values) { create_list(:property_value, 3, property:) }
      it 'delete property and nested values' do
        expect do
          delete :destroy, params: { id: property }, format: :turbo_stream
        end.to change(Property, :count).by(-1) && change(PropertyValue, :count).by(-3)
      end
    end
  end
end
