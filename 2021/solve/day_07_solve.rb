require 'day_07'

def solution_to_part_one
  input = File.read 'data/day_07_input.txt'
  crabs = Crabs.parse input
  cost  = crabs.lowest_fuel_cost

  "The least amount of fuel needed to align is #{cost}."
end

def solution_to_part_two
  input = File.read 'data/day_07_input.txt'
  crabs = NewCrabs.parse input
  cost  = crabs.lowest_fuel_cost

  "The least amount of fuel needed to align is #{cost}."
end

puts "Day 7: The Treachery of Whales"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
