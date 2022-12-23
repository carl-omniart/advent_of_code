require 'day_03'

def solution_to_part_one
  input     = File.read 'data/day_03_input.txt'
  rucksacks = RucksackReorganization.parse input
  rucksacks.map { |rucksack| rucksack.common_item_priority }.sum
end

def solution_to_part_two
  input     = File.read 'data/day_03_input.txt'
  rucksacks = RucksackReorganization.parse input
  groups    = RucksackReorganization.group *rucksacks
  groups.map(&:badge_priority).sum
end

puts "Day 3: Rucksack Reorganization"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
