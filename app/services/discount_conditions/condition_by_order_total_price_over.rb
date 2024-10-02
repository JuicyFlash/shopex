class ConditionByOrderTotalPriceOver < AbstractCondition
  def self.description
    "Скидка если сумма заказа больше указанной"
  end

  def prepare(condition)
    condition.to_f
  end

  def satisfies?(product, options = {})
    order = options[:order]
    return false if order.nil?

    order.total.to_f >= @condition
  end
end
