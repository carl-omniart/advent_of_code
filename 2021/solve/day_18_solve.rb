require 'day_18'

def solution_to_part_one
  input = File.read 'data/day_18_input.txt'
  sum   = Snailfish.parse(input).inject :+

  "The magnitude of the final sum is #{sum.magnitude}."
end

def solution_to_part_two
  input      = File.read 'data/day_18_input.txt'
  magnitudes = input.split("\n").permutation(2).map do |lines|
    Snailfish.parse(lines.join("\n")).inject(:+).magnitude
  end
  
  "The largest magnitude of any sum of two different snailfish numbers is #{magnitudes.max}."
end

puts "Day 18: Snailfish"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
