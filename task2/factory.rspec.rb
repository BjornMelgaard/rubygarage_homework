require_relative 'factory'

describe Factory do
  after(:each) do
    Object.send(:remove_const, :Customer)
  end

  it 'can create class without instance variables' do
    Customer = Factory.new
    customer = Customer.new
    expect(customer.instance_variables).to eq([])
  end

  context 'created class instance' do
    before(:each) do
      Customer = Factory.new(:name, :address, :zip) do
        def greeting
          "Hello #{name}!"
        end
      end
    end
    let(:joe) { Customer.new('Joe Smith', '123 Maple, Anytown NC', 12345) }

    it 'have instance variables' do
      [:name, :address, :zip].each do |arg|
        expect(joe.instance_variable_defined?("@#{arg}")).to be_truthy
      end
      expect(joe.name).to     eq('Joe Smith')
    end

    it 'respond with []' do
      expect(joe['name']).to  eq('Joe Smith')
      expect(joe[:name]).to   eq('Joe Smith')
      expect(joe[0]).to       eq('Joe Smith')
    end

    it 'have methods from block' do
      expect(joe.greeting).to eq('Hello Joe Smith!')
    end
  end
end
