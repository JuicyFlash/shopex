class AbstractCondition

  def initialize(condition)
    @condition = prepare(condition)
  end

  def self.description
    raise "#{__method__} undefined"
  end

  def prepare(condition)
    raise "#{__method__} undefined"
  end

  def satisfies?(product, options = {})
    raise "#{__method__} undefined for #{self.class}"
  end
end