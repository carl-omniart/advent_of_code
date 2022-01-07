require 'day_10'

def solution_to_part_one
  input   = File.read 'data/day_10_input.txt'
  syntax  = Syntax.parse input
  sum     = syntax.total_syntax_error_score

  "The total syntax error score is #{sum}."
end

def solution_to_part_two
  input   = File.read 'data/day_10_input.txt'
  syntax  = Syntax.parse input
  median  = syntax.median_needed_closers_score

  "The middle score for the scored completion strings is #{median}."
end

puts "Day 10: Syntax Scoring"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
