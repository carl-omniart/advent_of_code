require 'day_03'

def solution_to_part_one
  input = File.read 'data/day_03_input.txt'
  diagnostic = Diagnostic.parse input

  gamma   = diagnostic.gamma_rate
  epsilon = diagnostic.epsilon_rate
  power   = diagnostic.power_consumption

  "Multiplying the gamma rating (#{gamma}) by the epsilon rating (#{epsilon}) equals a power consumption of #{power}."
end

def solution_to_part_two
  input = File.read 'data/day_03_input.txt'
  diagnostic = Diagnostic.parse input

  oxygen        = diagnostic.oxygen_generator_rating
  co2           = diagnostic.co2_scrubber_rating
  life_support  = diagnostic.life_support_rating

  "Multiplying the oxygen generator rating (#{oxygen}) by the co2 scrubber rating (#{co2}) equals a life support rating of #{life_support}."
end

puts "Day 3: Binary Diagnostic"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts