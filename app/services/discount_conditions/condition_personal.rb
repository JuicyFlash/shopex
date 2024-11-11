class ConditionPersonal < AbstractCondition

  def self.description
    "Если пользователь в указанном списке пользователей (id)"
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
