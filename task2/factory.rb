class Factory
  def self.new(*f_args, &block)
    Class.new do
      attr_accessor(*f_args)

      define_method :initialize do |*i_args|
        f_args.zip(i_args).each { |(f_arg, i_arg)| send("#{f_arg}=", i_arg) }
      end

      define_method :[] do |param|
        param = f_args[param] if param.is_a? Numeric
        send(param)
      end

      class_eval(&block) if block_given?
    end
  end
end
