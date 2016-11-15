module EqualityByAttributes
  def attributes
    instance_variables.map { |v| instance_variable_get(v) }
  end

  def ==(other)
    other.class == self.class && other.attributes == attributes
  end
end
