class Product < ApplicationRecord
  belongs_to :brand
  has_many_attached :images, dependent: :destroy

  validates :title, :description, presence: true
end
