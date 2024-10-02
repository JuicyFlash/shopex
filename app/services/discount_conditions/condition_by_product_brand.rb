class ConditionByProductBrand < AbstractCondition

  def self.description
    "Скидка на указанный перечень id брэндов"
  end

  def prepare(condition)
    condition.split(',').map{ |id| id.to_i }
  end

  def satisfies?(product, options = {})
    @condition.include?(product.brand.id)
  end
end