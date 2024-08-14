class Product < ApplicationRecord
  belongs_to :brand
  has_many :product_property, dependent: :destroy

  accepts_nested_attributes_for :product_property, reject_if: proc { |attributes|
                                                                      attributes['property_value_id'].blank? ||
                                                                      attributes['property_value_id'].to_i < 0
                                                                   }

  has_many_attached :images, dependent: :destroy

  validates :title, :description, presence: true

  scope :by_brands, -> (brands) { where(:brand_id => brands) unless (brands || []).empty? }

  scope :with_property_values, -> (values) do
    unless (values || []).empty?
       property_filter =  values.map{ |v| "EXISTS ( SELECT 1 FROM product_properties WHERE product_properties.product_id = products.id
                                                                                              AND
                                                                                           property_value_id = #{v})" }.join(' AND ')

       joins(:product_property).where(property_filter).distinct
     end
  end

  def property_value?(value)
    !product_property.find_by(property_value_id: value.id).nil?
  end

  def name
    "#{brand.title} #{title}"
  end
end
