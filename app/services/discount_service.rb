class DiscountService
  Dir[File.dirname(__FILE__) + '/discount_conditions/*.rb'].each {|file| require file }
  TARGETS = %w[catalog order personal].freeze
  CONDITION_TYPES = { discount_personal: ConditionPersonal,
                      discount_by_product_brand: ConditionByProductBrand,
                      discount_by_product_id: ConditionByProductId,
                      # discount_by_product_property: DiscountByProductProperty,
                      discount_by_order_total_price_over: ConditionByOrderTotalPriceOver
  }.freeze
  def initialize
    @discounts = []
  end

  def configure
    Discount.where(active: true).find_each do |discount|
      @discounts << { discount_record: discount,
                      discount_conditions: discount_conditions(discount) }
    end
  end

  def discount_for(product, target, options = {})
    return if target.nil?

    discount_value = 0
    discount_personal = satisfies_discounts(product, 'personal', options).max { |a, b|  a.value <=> b.value }
    discount_catalog = satisfies_discounts(product, 'catalog', options).max { |a, b|  a.value <=> b.value }
    discount_order = satisfies_discounts(product, 'order', options).max { |a, b|  a.value <=> b.value }if target == 'order'

    discount_value += discount_catalog.value unless discount_catalog.nil?
    discount_value += discount_personal.value unless discount_personal.nil?
    discount_value += discount_order.value unless discount_order.nil?

    { discount_value: discount_value,
      discount_price: product.price - (product.price / 100 * discount_value)
    }
  end

  def available_discounts
    @discounts
  end

  def self.targets
    TARGETS
  end

  def self.condition_types
    CONDITION_TYPES
  end

  private

  def satisfies_discounts(product, target, options)
    satisfies_discounts = []
    available_discounts.find_all { |discount| discount[:discount_record].target == target }.each do | discount |
      satisfies_discounts << discount[:discount_record] if conditions_satisfy?(discount[:discount_conditions], product, options)
    end
    satisfies_discounts
  end

  def discount_conditions(discount)
    conditions = []
    discount.conditions.find_each do |condition|
      conditions << DiscountService.condition_types[condition.condition_type.to_sym].new(condition.value)
    end
    conditions
  end

  def conditions_satisfy?(discount_conditions, product, options)
    return false if discount_conditions.empty?

    discount_conditions.map { |condition| condition.satisfies?(product, options) }.all?(true)
  end
end
