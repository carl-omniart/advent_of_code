require 'day_08'

def solution_to_part_one
  input  = File.read 'data/day_08_input.txt'
  forest = TreetopTreeHouse.parse input
  forest.visible_tree_count
end

def solution_to_part_two
  input  = File.read 'data/day_08_input.txt'
  forest = TreetopTreeHouse.parse input
  forest.scenic_scores.max
end

puts "Day 8: Treetop Tree House"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
