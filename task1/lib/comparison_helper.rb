module ComparisonHelper
  def state
    instance_variables.map { |v| instance_variable_get(v) }
  end

  def ==(other)
    other.class == self.class && other.state == state
  end
end
