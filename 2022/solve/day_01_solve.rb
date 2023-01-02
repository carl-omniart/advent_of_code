require 'day_01'

def solution_to_part_one
  input = File.read 'data/day_01_input.txt'
  elves = CalorieCounting.get_elves input
  elves.map(&:total_calories).max
end

def solution_to_part_two
  input = File.read 'data/day_01_input.txt'
  elves = CalorieCounting.get_elves input
  elves.map(&:total_calories).max(3).sum
end

puts "Day 1: Calorie Counting"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
