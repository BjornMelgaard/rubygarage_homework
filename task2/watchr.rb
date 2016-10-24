watch('factory.*.rb') do |md|
  system 'rspec -c ./factory.rspec.rb'
end
