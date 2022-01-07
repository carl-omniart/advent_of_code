require 'day_14'

def solution_to_part_one
  input   = File.read 'data/day_14_input.txt'
  polymer = Polymer.parse input
  polymer.advance_to 10
  diff    = polymer.count_difference_between_most_and_least_common_elements

  "After 10 steps, the difference between the quantities of the most and least common elements is #{diff}."
end

def solution_to_part_two
  input   = File.read 'data/day_14_input.txt'
  polymer = Polymer.parse input
  polymer.advance_to 40
  diff    = polymer.count_difference_between_most_and_least_common_elements

  "After 40 steps, the difference between the quantities of the most and least common elements is #{diff}."
end

puts "Day 14: Extended Polymerization"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
