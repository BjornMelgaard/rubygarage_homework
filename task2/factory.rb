#
class Factory
  def self.new(*f_args, &block)
    Class.new do
      attr_accessor(*f_args)

      define_method :initialize do |*i_args|
        f_args.zip(i_args).each { |(f_arg, i_arg)| send("#{f_arg}=", i_arg) }
      end

      def [](param)
        param = instance_variables[param][1..-1] if param.is_a? Numeric
        instance_variable_get("@#{param}")
      end

      class_eval(&block) if block_given?
    end
  end
end
