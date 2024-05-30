require 'rails_helper'

RSpec.describe Property, type: :model do
  it { should have_many(:property_values).dependent(:destroy) }
end
