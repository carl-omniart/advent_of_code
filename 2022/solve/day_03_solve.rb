require 'day_03'

def solution_to_part_one
  input     = File.read 'data/day_03_input.txt'
	rucksacks = Rucksack.parse input
  this_many = rucksacks.map { |rucksack| rucksack.common_items_priority }.sum
  
  "The sum of the priorities of the rucksacks' common items is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_03_input.txt'
	rucksacks = Rucksack.parse input
  groups    = rucksacks.each_slice(3).map { |sacks| ElfGroup.new *sacks }
  this_many = groups.map(&:badge_priority).sum
  
  "The sum of the priorities of the elf groups' badges is #{this_many}."
end

puts "Day 3: Rucksack Reorganization"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
