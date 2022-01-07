require 'day_17'

def solution_to_part_one
  input     = File.read 'data/day_17_input.txt'
  launcher  = Launcher.parse input
  max_y     = launcher.max_y

  "The highest y position reached on a valid trajectory is #{max_y}."
end

def solution_to_part_two
  input     = File.read 'data/day_17_input.txt'
  launcher  = Launcher.parse input
  count     = launcher.all_initial_velocities.size
  
  "The number of distinct initial velocity values that cause the probe to be within the target area after any step is #{count}."
end

puts "Day 17: Trick Shot"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
