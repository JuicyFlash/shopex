require 'rails_helper'

RSpec.describe DiscountCondition, type: :model do
  it { should belong_to(:discount).optional(true) }

  it { should validate_presence_of(:condition_type) }
end
