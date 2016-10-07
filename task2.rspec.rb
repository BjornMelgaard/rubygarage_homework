require_relative 'task2'

describe Factory do
  it 'have given class variables' do
    Customer = Factory.new(:name, :address, :zip) do
      def greeting
        "Hello #{name}!"
      end
    end
    puts "Customer ancestors = #{Customer.ancestors.join(', ')}"

    joe = Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345)
    [:name, :address, :zip].each do |arg|
      expect(joe.instance_variable_defined?("@#{arg}")).to be_truthy
    end
    expect(joe.name).to     eq('Joe Smith')
    expect(joe['name']).to  eq('Joe Smith')
    expect(joe[:name]).to   eq('Joe Smith')
    expect(joe[0]).to       eq('Joe Smith')
    expect(joe.greeting).to eq('Hello Joe Smith!')
  end
end
