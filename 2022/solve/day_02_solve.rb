require 'day_02'

def solution_to_part_one
  input          = File.read 'data/day_02_input.txt'
  strategy_guide = RockPaperScissors.parse input
  strategy_guide.my_score
end

def solution_to_part_two
  input          = File.read 'data/day_02_input.txt'
  strategy_guide = RockPaperScissors.parse input, updated: true  
  strategy_guide.my_score
end

puts "Day 2: Rock Paper Scissors"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
