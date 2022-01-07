require 'day_12'

def solution_to_part_one
  input = File.read 'data/day_12_input.txt'
  caves = CaveSystem.parse input
  count = caves.paths_that_visit_no_small_cave_twice.size

  "The number of unique paths through the cave system that do not visit a small cave more than once is #{count}."
end

def solution_to_part_two
  input = File.read 'data/day_12_input.txt'
  caves = CaveSystem.parse input
  count = caves.paths_that_visit_one_small_cave_twice.size

  "The number of unique paths through the cave system that do not visit more than one small cave twice is #{count}."
end

puts "Day 12: Passage Pathing"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
