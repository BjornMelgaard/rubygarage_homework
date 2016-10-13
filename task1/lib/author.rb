class Author
  attr_accessor :name, :biography
  include ComparisonHelper

  def initialize(name, biography)
    @name = name
    @biography = biography
  end
end
