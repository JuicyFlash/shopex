require 'rails_helper'

RSpec.describe PropertyValue, type: :model do
  it { should belong_to(:property) }
end
