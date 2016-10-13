class Reader
  attr_accessor :name, :email, :city, :street, :house
  include ComparisonHelper

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
