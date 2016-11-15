require_relative 'equality_by_attributes'
require_relative 'author'
require_relative 'book'
require_relative 'order'
require_relative 'reader'

require 'date'
require 'base64'

# factory
class Library
  attr_accessor :books, :orders, :readers, :authors
  include EqualityByAttributes

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

  # program functionality

  def best_reader
    @orders.group_by(&:reader).values.max_by(&:size).first.reader
  end

  def bestseller
    @orders.group_by(&:book).values.max_by(&:size).first.book
  end

  def books_with_popularity(size)
    @orders
      .group_by(&:book)
      .map { |book, orders| [book, orders.size] }
      .max_by(size) { |_book, order_count| order_count }
  end

  def save(path = 'library.file')
    encode = Base64.encode64(Marshal.dump(self))
    File.open(path, 'wb') { |f| f.write(encode) }
  end

  def self.load(path = 'library.file')
    content = File.read(path)
    Marshal.load(Base64.decode64(content))
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
