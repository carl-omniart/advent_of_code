require 'day_07'

def solution_to_part_one
  input = File.read 'data/day_07_input.txt'
  disk  = NoSpaceLeftOnDevice.parse input
  disk.root.each_dir.map(&:size).select { |s| s <= 100_000 }.sum
end

def solution_to_part_two
  input           = File.read 'data/day_07_input.txt'
  disk            = NoSpaceLeftOnDevice.parse input
  update_space    = 30_000_000
  space_to_delete = update_space - disk.unused_space
  
  disk.root.each_dir.map(&:size).select { |size| size >= space_to_delete }.min
end

puts "Day 7: No Space Left On Device"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
