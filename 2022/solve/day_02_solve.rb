require 'day_02'

def solution_to_part_one
  input     = File.read 'data/day_02_input.txt'
  guide     = StrategyGuide.parse input
  this_many = guide.calculate_my_score
  
  "My total score if everything goes exactly according to the strategy guide is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_02_input.txt'
  guide     = SonOfStrategyGuide.parse input
  this_many = guide.calculate_my_score
  
  "My total score if everything goes exactly according to the strategy guide is #{this_many}."
end

puts "Day 2: Rock Paper Scissors"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
