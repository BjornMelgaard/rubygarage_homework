watch('lib.*.rb') do |md|
  system "rspec -c ./spec/lib.rspec.rb"
end
