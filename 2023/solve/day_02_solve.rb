require 'day_02'

def solution_to_part_one
  input          = File.read 'data/day_02_input.txt'
  games          = CubeConundrum.parse_games input
  bag            = CubeConundrum::Bag.new red: 12, green: 13, blue: 14
  possible_games = games.select { |game| bag.possible_game? game }
  possible_games.map(&:id).sum
end

def solution_to_part_two
  input        = File.read 'data/day_02_input.txt'
  games        = CubeConundrum.parse_games input
  bags         = games.map { |game| CubeConundrum::Bag.new **game.maxes }
  bags.map(&:power).sum
end

puts "Day 1: Cube Conundrum"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
