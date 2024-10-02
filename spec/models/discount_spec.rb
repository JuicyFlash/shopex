require 'rails_helper'

RSpec.describe Discount, type: :model do
  it { should have_many(:conditions).dependent(:destroy) }

  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:value).is_less_than_or_equal_to(100) }
end
