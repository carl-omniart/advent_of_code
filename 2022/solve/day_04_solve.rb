require 'day_04'

def solution_to_part_one
  input       = File.read 'data/day_04_input.txt'
	assignments = SectionAssignments.parse input
  this_many   = assignments.count &:fully_contained?
  
  "The number of assignment pairs in which one range fully contains the other is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_04_input.txt'
	assignments = SectionAssignments.parse input
  this_many   = assignments.count &:overlap?
  "The number of assignment pairs in which one range overlaps the other is #{this_many}."
end

puts "Day 4: Camp Cleanup"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
