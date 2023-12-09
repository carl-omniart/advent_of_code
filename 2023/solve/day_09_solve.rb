require 'day_09'

def solution_to_part_one
  input = File.read 'data/day_09_input.txt'
  oasis = MirageMaintenance::OASIS.parse input
  oasis.histories.map(&:predicted_next_value).sum
end

def solution_to_part_two
  input = File.read 'data/day_09_input.txt'
  oasis = MirageMaintenance::OASIS.parse input
  oasis.histories.map(&:predicted_prev_value).sum
end

puts "Day 9: Mirage Maintenance"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
