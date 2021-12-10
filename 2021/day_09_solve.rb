require_relative 'day_09.rb'

file_path = Dir.pwd + "/day_09_input.txt"
input     = File.readlines(file_path).map &:strip

map  = HeightMap.new *input
sum  = map.risk_level_sum

puts "1. The sum of risk levels on the low points on the heightmap is #{sum}."

product = map.product_of_three_largest_basin_sizes

puts "2. The product of the sizes of the three largest basins is #{product}."
