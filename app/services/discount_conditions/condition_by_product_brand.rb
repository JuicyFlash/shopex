class ConditionByProductBrand < AbstractCondition

  def self.description
    "Если брэнд товара входит в перечень брэндов (id)"
  end

  def prepare(condition)
    condition.split(',').map{ |brand| Brand.find_by(title: brand) }.select { |brand| brand.id if !brand.nil? }.map{ |brand| brand.id.to_i }
  end

  def satisfies?(product, options = {})
    @condition.include?(product.brand.id)
  end
end