require 'day_05'

def solution_to_part_one
  input = File.read 'data/day_05_input.txt'
  almanac = IfYouGiveASeedAFertilizer::ObjectAlmanac.parse input
  almanac.locations.map(&:min).min
end

def solution_to_part_two
  input = File.read 'data/day_05_input.txt'
  almanac = IfYouGiveASeedAFertilizer::SetAlmanac.parse input
  almanac.locations.map(&:min).min
end


puts "Day 5: If You Give A Seed A Fertilizer"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
