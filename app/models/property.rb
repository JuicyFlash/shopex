class Property < ApplicationRecord
  has_many :property_values, dependent: :destroy

  accepts_nested_attributes_for :property_values, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true

  def self.with_values
    Property.joins(:property_values).distinct
  end

  def self.unique_property?(property_id)
    Property.find_by(id: property_id).unique
  end
end
