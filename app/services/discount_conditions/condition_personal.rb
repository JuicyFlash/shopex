class ConditionPersonal < AbstractCondition

  def self.description
    "Скидка на указанный перечень id товаров"
  end

  def prepare(condition)
    condition.split(',').map{ |id| id.to_i }
  end

  def satisfies?(product, options = {})
    user = options[:user]
    return false if user.nil?

    @condition.include?(user.id)
  end
end
