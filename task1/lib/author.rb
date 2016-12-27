class Author
  attr_accessor :name, :biography
  include EqualityByAttributes

  def initialize(name, biography)
    @name = name
    @biography = biography
  end
end
