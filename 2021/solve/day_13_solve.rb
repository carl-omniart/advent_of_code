require 'day_13'

def solution_to_part_one
  input     = File.read 'data/day_13_input.txt'
  paper     = Paper.parse input
  paper.fold
  this_many = paper.visible_dot_count

  "The number of dots visible after one fold is #{this_many}."
end

def solution_to_part_two
  input = File.read 'data/day_13_input.txt'
  paper = Paper.parse input
  paper.fold_all.visible_dots
end

puts "Day 13: Transparent Origami"
puts "1. #{solution_to_part_one}"
puts "2."
puts solution_to_part_two
puts
