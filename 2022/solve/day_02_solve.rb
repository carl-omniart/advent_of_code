require 'day_02'

def solution_to_part_one
  input = File.read 'data/day_02_input.txt'
  guide = RockPaperScissors::StrategyGuide.parse input
  guide.simulate_game.score.last
end

def solution_to_part_two
  input = File.read 'data/day_02_input.txt'
  guide = RockPaperScissors::UpdatedStrategyGuide.parse input
  guide.simulate_game.score.last
end

puts "Day 2: Rock Paper Scissors"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
