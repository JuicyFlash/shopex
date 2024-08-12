class Product < ApplicationRecord
  belongs_to :brand
  has_many :product_property, dependent: :destroy

  accepts_nested_attributes_for :product_property, reject_if: proc { |attributes|
                                                                attributes['property_value_id'].blank? ||
                                                                  attributes['property_value_id'].to_i < 0
                                                              }

  has_many_attached :images, dependent: :destroy

  validates :title, :description, presence: true

  scope :by_brands, -> (brands) do
    return where('1 = 1') if (brands || []).empty?

    where(:brand_id => brands)
  end

  scope :with_property_values, -> (values) do
     return where('1 = 1') if (values || []).empty?

     property_filter =  values.map{ |v| "EXISTS ( SELECT 1 FROM product_properties WHERE product_properties.product_id = products.id
                                                                                            AND
                                                                                         property_value_id = #{v})" }.join(' AND ')

     joins(:product_property).where(property_filter).distinct
  end

  def self.get_products_by_params(params)
    brands = params[:brands] || []
    properties_values = []
    params[:properties].values.map{ |v| v }.each { |i| properties_values.concat(i) } || []

    Product.by_brands(brands).with_property_values(properties_values)
  end

  def property_value?(value)
    !product_property.find_by(property_value_id: value.id).nil?
  end

  def name
    "#{brand.title} #{title}"
  end
end
