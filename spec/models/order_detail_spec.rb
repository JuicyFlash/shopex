# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  it { should belong_to(:order).optional }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:house_number) }
  it { should validate_presence_of(:phone_number) }
end
