require_relative 'decorators'

describe Decorators do
  let(:klass) do
    Class.new do
      include Decorators

      add_prefix('hello ')
      def a
        'from a'
      end

      def b
        'from b'
      end

      add_prefix('hello2 ')
      def с(arg1, arg2)
        "from с, arg1 = #{arg1}, arg2=#{arg2}"
      end
    end
  end

  let(:instance) { klass.new }

  it 'should add prefix only to one subsequent method' do
    expect(instance.a).to eq('hello from a')
    expect(instance.b).to eq('from b')
    expect(instance.с 'arg1', 'arg2').to eq('hello2 from с, arg1 = arg1, arg2=arg2')
  end
end
