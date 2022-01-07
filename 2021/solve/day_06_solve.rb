require 'day_06'

def solution_to_part_one
  input     = File.read 'data/day_06_input.txt'
  fish      = Lanternfish.parse input
  fish.age_until 80
  this_many = fish.count

  "After 80 days, there are #{this_many} fish in the school."
end

def solution_to_part_two
  input     = File.read 'data/day_06_input.txt'
  fish      = Lanternfish.parse input
  fish.age_until 256
  this_many = fish.count

  "After 256 days, there are #{this_many} fish in the school."
end

puts "Day 6: Lanternfish"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
