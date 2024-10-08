# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:brand) }
  it { should have_many(:product_property).dependent(:destroy) }
  it { should have_many(:properties) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many_attached(:images) }
end
