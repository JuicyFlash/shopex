# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CartProduct, type: :model do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }

  it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
end
