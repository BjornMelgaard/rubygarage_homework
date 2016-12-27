def attribute(name, &default_block)
  name, default_value = name.to_a.first if name.is_a? Hash
  default_block ||= proc { default_value }

  define_method name do
    if instance_variable_defined? "@#{name}"
      instance_variable_get "@#{name}"
    elsif default_block
      instance_eval(&default_block)
    end
  end

  define_method "#{name}=" do |var|
    instance_variable_set("@#{name}", var)
  end

  alias_method "#{name}?", name
end
