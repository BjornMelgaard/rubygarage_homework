require 'date'

#
module InternalEquality
  def state
    instance_variables.map { |v| instance_variable_get(v) }
  end

  def ==(other)
    other.class == self.class && other.state == state
  end
end

# factory
class Library
  attr_accessor :books, :orders, :readers, :authors
  include InternalEquality

  def initialize
    @books = []
    @orders = []
    @readers = []
    @authors = []
  end

  def create_book(title, author)
    book = Book.new(title, author)
    record_as :book, book
  end

  def create_author(name, biography = nil)
    author = Author.new(name, biography)
    record_as :author, author
  end

  def create_reader(name, email = nil, city = nil, street = nil, house = nil)
    reader = Reader.new(name, email, city, street, house)
    reader.register_in(self)
    record_as :reader, reader
  end

  def create_order(book, reader)
    order = Order.new(book, reader, DateTime.now)
    record_as :order, order
  end

  private

  def record_as(key, obj)
    key = ('@' + key.to_s + 's').to_sym
    raise ArgumentError, "Library doesn't have such attribute: #{key}" unless instance_variable_defined?(key)
    arr = instance_variable_get(key)
    arr << obj
    obj
  end
end

Order = Struct.new(:book, :reader, :date) { include InternalEquality }

Book = Struct.new(:title, :author) { include InternalEquality }

Author = Struct.new(:name, :biography) { include InternalEquality }

Reader = Struct.new(:name, :email, :city, :street, :house) do
  include InternalEquality

  def register_in(library)
    @library = library
  end

  def take(book)
    handle_empty_library unless @library
    @library.create_order(book, self)
  end

  private

  def handle_empty_library
    raise "Reader #{@name} must be registered in library"
  end
end
