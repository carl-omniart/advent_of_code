require 'day_03'

def solution_to_part_one
  input     = File.read 'data/day_03_input.txt'
  schematic = GearRatios::Schematic.parse input
  schematic.part_numbers.map(&:value).sum
end

def solution_to_part_two
  input     = File.read 'data/day_03_input.txt'
  schematic = GearRatios::Schematic.parse input
  schematic.gears.map(&:gear_ratio).sum
end


puts "Day 3: Gear Ratios"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
