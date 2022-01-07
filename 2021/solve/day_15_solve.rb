require 'day_15'

def solution_to_part_one
  input   = File.read 'data/day_15_input.txt'
  cavern  = Cavern.parse input
  cavern.calculate_total_risk
  risk  = cavern.lowest_total_risk

  "The path with the lowest total risk has a lowest total risk of #{risk}."
end

def solution_to_part_two
  input   = File.read 'data/day_15_input.txt'
  cavern  = BigCavern.parse input
  cavern.calculate_total_risk
  risk    = cavern.lowest_total_risk

  "The path with the lowest total risk has a lowest total risk of #{risk}."
end

puts "Day 15: Chiton"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
