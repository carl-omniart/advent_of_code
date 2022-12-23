require 'day_04'

def solution_to_part_one
  input       = File.read 'data/day_04_input.txt'
  assignments = CampCleanup.parse input
  assignments.count &:fully_contained?
end

def solution_to_part_two
  input       = File.read 'data/day_04_input.txt'
  assignments = CampCleanup.parse input
  assignments.count &:overlap?
end

puts "Day 4: Camp Cleanup"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
