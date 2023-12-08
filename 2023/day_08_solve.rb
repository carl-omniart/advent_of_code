require 'day_08'

def solution_to_part_one
  input = File.read 'data/day_08_input.txt'
  map   = HauntedWasteland::Map.parse input
  map.steps_to_zzz
end

def solution_to_part_two
  input = File.read 'data/day_08_input.txt'
  map   = HauntedWasteland::Map.parse input
  map.ghost_steps_to_z
end

puts "Day 7: Haunted Wasteland"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
