# frozen_string_literal: true

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should have_one(:cart).dependent(:destroy) }
end
