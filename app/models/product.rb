class Product < ApplicationRecord
  belongs_to :brand
  has_many_attached :pictures, dependent: :destroy

  validates :title, :description, presence: true
end
