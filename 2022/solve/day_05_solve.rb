require 'day_05'

def solution_to_part_one
  input = File.read 'data/day_05_input.txt'
  dock  = SupplyStacks.parse input
  dock.rearrange_stacks!
  dock.stacks.map(&:top_crate).join
end

def solution_to_part_two
  input = File.read 'data/day_05_input.txt'
  dock  = SupplyStacks.parse input, crate_mover_model: 9001
  dock.rearrange_stacks!
  dock.stacks.map(&:top_crate).join
end

puts "Day 5: Supply Stacks"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
