require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should have_many(:order_products).dependent(:destroy) }
  it { should have_many(:products) }
  it { should belong_to(:user).optional(true) }
  it { should have_one(:detail) }

end
