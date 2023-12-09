require 'day_08'

def solution_to_part_one
  input = File.read 'data/day_08_input.txt'
  map   = HauntedWasteland::Map.parse input
  map.steps_between :AAA, :ZZZ
end

def solution_to_part_two
  input = File.read 'data/day_08_input.txt'
  map   = HauntedWasteland::Map.parse input
  map.ghost_syzygy
end

puts "Day 8: Haunted Wasteland"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
