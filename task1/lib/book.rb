class Book
  attr_accessor :title, :author
  include ComparisonHelper

  def initialize(title, author)
    @title = title
    @author = author
  end
end
