watch('lib.*.rb') do |md|
  system "rspec -c ./lib.rspec.rb"
end
