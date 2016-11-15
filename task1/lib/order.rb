class Order
  attr_accessor :book, :reader, :date
  include EqualityByAttributes

  def initialize(book, reader, date)
    @book = book
    @reader = reader
    @date = date
  end
end
