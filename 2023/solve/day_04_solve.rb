require 'day_04'

def solution_to_part_one
  input = File.read 'data/day_04_input.txt'
  game  = Scratchcards::Game.parse input
  game.points
end

def solution_to_part_two
  input = File.read 'data/day_04_input.txt'
  game  = Scratchcards::Game.parse input
  game.copies
end


puts "Day 4: Scratchcards"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
