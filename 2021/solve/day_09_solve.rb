require 'day_09'

def solution_to_part_one
  input   = File.read 'data/day_09_input.txt'
  map     = HeightMap.parse input
  sum     = map.risk_level_sum

  "The sum of risk levels on the low points on the heightmap is #{sum}."
end

def solution_to_part_two
  input   = File.read 'data/day_09_input.txt'
  map     = HeightMap.parse input
  product = map.product_of_three_largest_basin_sizes

  "The product of the sizes of the three largest basins is #{product}."
end

puts "Day 9: Smoke Basin"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
