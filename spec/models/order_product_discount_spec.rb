require 'rails_helper'

RSpec.describe OrderProductDiscount, type: :model do
  it { should belong_to(:order_product).optional }
  it { should belong_to(:discount).optional }
end
