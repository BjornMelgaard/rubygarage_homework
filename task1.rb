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

#
class Order
  attr_accessor :book, :reader, :date
  include InternalEquality

  def initialize(book, reader, date)
    @book = book
    @reader = reader
    @date = date
  end
end

#
class Book
  attr_accessor :title, :author
  include InternalEquality

  def initialize(title, author)
    @title = title
    @author = author
  end
end

#
class Author
  attr_accessor :name, :biography
  include InternalEquality

  def initialize(name, biography)
    @name = name
    @biography = biography
  end
end

#
class Reader
  attr_accessor :name, :email, :city, :street, :house
  include InternalEquality

  def initialize(name, email, city, street, house)
    @name = name
    @email = email
    @city = city
    @street = street
    @house = house
  end

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
