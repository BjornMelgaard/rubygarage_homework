class Book
  attr_accessor :title, :author
  include EqualityByAttributes

  def initialize(title, author)
    @title = title
    @author = author
  end
end
