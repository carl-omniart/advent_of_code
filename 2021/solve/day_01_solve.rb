require 'day_01'

def solution_to_part_one
  input     = File.read 'data/day_01_input.txt'
  sonar     = Sonar.parse input
  this_many = sonar.depths_increase_count

  "The number of times that depth measurements increase is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_01_input.txt'
  sonar     = Sonar.parse input
  this_many = sonar.sliding_window_sums_increase_count 3

  "The number of times that three-measurement sliding window sums increase is #{this_many}."
end

puts "Day 1: Sonar Sweep"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
