class ConditionByProductId < AbstractCondition

  def self.description
    "Если товар входит в перечень товаров (id)"
  end

  def prepare(condition)
    condition.split(',').map{ |id| id.to_i }
  end

  def satisfies?(product, options = {})
    @condition.include?(product.id)
  end
end
