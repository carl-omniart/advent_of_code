require 'day_07'

def solution_to_part_one
  input = File.read 'data/day_07_input.txt'
  game  = CamelCards::Game.parse input
  game.winnings.sum
end

def solution_to_part_two
  input = File.read 'data/day_07_input.txt'
  game  = CamelCards::GameWithJokers.parse input
  game.winnings.sum
end

puts "Day 7: Camel Cards"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
