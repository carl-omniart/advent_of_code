require_relative 'day_11.rb'

file_path = Dir.pwd + "/day_11_input.txt"
input     = File.readlines(file_path).map &:strip

octopi = Octopi.new *input
octopi.advance_to 100
count  = octopi.flash_count

puts "1. The total number of flashes after 100 steps is #{count}."

octopi = Octopi.new *input
octopi.advance_to_all_flash
step = octopi.step

puts "2. The first step at which all octopi flash is #{step}."
