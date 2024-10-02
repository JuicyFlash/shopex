require 'rails_helper'

RSpec.describe DiscountCondition, type: :model do
  it { should belong_to(:discount) }
end
