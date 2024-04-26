class Product < ApplicationRecord

  belongs_to :brand

  validates :title, :description, presence: true
end
