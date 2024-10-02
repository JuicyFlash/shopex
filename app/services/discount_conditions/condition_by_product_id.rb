class ConditionByProductId < AbstractCondition

  def self.description
    "Скидка на указанный перечень id товаров"
  end

  def prepare(condition)
    condition.split(',').map{ |id| id.to_i }
  end

  def satisfies?(product, options = {})
    @condition.include?(product.id)
  end
end
