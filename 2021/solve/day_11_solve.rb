require 'day_11'

def solution_to_part_one
  input     = File.read 'data/day_11_input.txt'
  octopi    = Octopi.parse input
  octopi.advance_to 100
  this_many = octopi.flash_count

  "The total number of flashes after 100 steps is #{this_many}."
end

def solution_to_part_two
  input   = File.read 'data/day_11_input.txt'
  octopi  = Octopi.parse input
  octopi.advance_to_all_flash
  step    = octopi.step

  "The first step at which all octopi flash is #{step}."
end

puts "Day 11: Dumbo Octopus"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
