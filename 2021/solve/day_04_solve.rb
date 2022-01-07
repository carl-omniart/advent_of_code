require 'day_04'

def solution_to_part_one
  input = File.read 'data/day_04_input.txt'
  
  game  = Bingo.parse input
  game.play!
  winner = game.winners.first
  
  "Multiplying the sum of unmarked numbers on the winning board (#{winner.unmarked_sum}) by the number that was just called (#{winner.last_marked}) equals a score of #{winner.score}."
end

def solution_to_part_two
  input = File.read 'data/day_04_input.txt'
  
  game  = Bingo.parse input
  game.play_to_lose!
  loser = game.losers.last

  "Multiplying the sum of unmarked numbers on the losing board (#{loser.unmarked_sum}) by the number that was just called (#{loser.last_marked}) equals a score of #{loser.score}."
end

puts "Day 4: Giant Squid"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
