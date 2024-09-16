require 'rails_helper'

RSpec.describe ProductProperty, type: :model do
  it { should belong_to(:property) }
  it { should belong_to(:property_value) }
  it { should belong_to(:product) }
end
