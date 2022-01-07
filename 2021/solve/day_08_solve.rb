require 'day_08'

def solution_to_part_one
  input     = File.read 'data/day_08_input.txt'
  displays  = Display.parse input
  this_many = displays.map { |display| display.unique_output_count }.sum

  "In the output values, there are #{this_many} instances of a digits that use a unique number of segments."
end

def solution_to_part_two
  input     = File.read 'data/day_08_input.txt'
  displays  = Display.parse input
  sum       = displays.map { |display| display.output_value.to_i }.sum

  "Adding up all the output values equals #{sum}."
end

puts "Day 8: Seven Segment Search"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
