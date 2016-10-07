#
class Factory
  def self.new(*f_args, &block)
    klass = Class.new do
      define_method :initialize do |*i_args|
        f_args.each_with_index { |name, i| instance_variable_set("@#{name}", i_args[i]) }
      end

      f_args.each do |arg|
        class_eval("def #{arg};@#{arg};end") # getter
        class_eval("def #{arg}=(val);@#{arg}=val;end") # setter
      end

      def [](param)
        param = instance_variables[param][1..-1] if param.is_a? Numeric
        instance_variable_get("@#{param}")
      end
    end
    klass.class_eval(&block) if block_given?
    klass
  end
end
