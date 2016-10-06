watch('task(\d+).*') do |md|
  system "rspec -c ./task#{md[1]}.rspec.rb"
end
