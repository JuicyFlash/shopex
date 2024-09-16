require 'rails_helper'

RSpec.describe PropertyValue, type: :model do
  it { should belong_to(:property) }
  it { should validate_presence_of(:value) }
end
