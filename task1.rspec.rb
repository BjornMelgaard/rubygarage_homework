require_relative 'task1'
require 'faker'

describe Library do
  let(:library) { Library.new }
  let(:author) { library.create_author(Faker::Book.author) }
  let(:reader) { library.create_reader(Faker::Name.name) }
  let(:book) { library.create_book(Faker::Book.title, author) }

  it 'should have empty attributes on init' do
    expect(library.state.map(&:size)).to eq([0, 0, 0, 0])
  end

  it 'should log book orders' do
    expect { reader.take(book) }
      .to change { library.orders.size }
      .from(0)
      .to(1)
  end
end

describe 'Program' do
  let(:library) { Library.new }

  5.times do |i|
    let!("author#{i}") { library.create_author(Faker::Book.author) }
    let!("reader#{i}") { library.create_reader(Faker::Name.name) }
    let!("book#{i}") { library.create_book(Faker::Book.title, send("author#{i}")) }
  end

  before do
    2.times { reader0.take(book0) }
    3.times { reader1.take(book1) }
    1.times { reader2.take(book2) }
    0.times { reader3.take(book3) }
    0.times { reader4.take(book4) }
  end

  it 'determine who often takes the book' do
    best_reader = library.readers
      .sort_by { |r| library.orders.select { |o| o.reader == r }.size }
      .last
    expect(best_reader).to eq(reader1)
  end

  it 'determine what is the most popular book' do
    bestseller = library.books
      .sort_by { |b| library.orders.select { |o| o.book == b }.size }
      .last
    expect(bestseller).to eq(book1)
  end

  it 'determine how many people ordered one of the three most popular books' do
    arr = library.books
      .map { |b| [b, library.orders.select { |o| o.book == b }.map(&:reader).size] }
      .sort_by(&:last)
      .reverse
      .take(3)

    expect(arr[0]).to eq([book1, 3])
    expect(arr[1]).to eq([book0, 2])
    expect(arr[2]).to eq([book2, 1])
  end

  it 'save and restore all library data from file' do
    File.open('library.file', 'wb') { |f| Marshal.dump(library, f) }

    File.open('library.file', 'rb') do |f|
      other_lib = Marshal.load(f)
      expect(other_lib).to eq(library)
    end
  end
end
