require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should have_many(:property_values).dependent(:destroy) }
  it { should validate_presence_of(:name) }

  describe 'property methods' do
    let!(:property) { create(:property, unique: true) }
    let!(:empty_property) { create(:property) }
    let!(:property_value) { create_list(:property_value, 3, property:) }

    it 'can return properties with values' do
      expect(Property.with_values).to include property
      expect(Property.with_values).to_not include empty_property
    end
    it 'can check unique property' do
      expect(Property.unique_property?(property.id)).to eq true
      expect(Property.unique_property?(empty_property.id)).to eq false
    end
  end
end
