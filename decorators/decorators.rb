#
module Decorators
  def self.included(receiver)
    receiver.extend ClassMethods
  end

  module ClassMethods
    def add_prefix(prefix)
      @watching = true
      @prefix = prefix
    end

    def method_added(method)
      return unless @watching

      @watching = false
      prefix = @prefix
      alias_method "real_#{method}", method
      define_method method do |*args, &block|
        prefix + send("real_#{method}", *args, &block)
      end
    end
  end
end
