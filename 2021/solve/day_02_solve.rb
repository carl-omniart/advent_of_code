require 'day_02'

def solution_to_part_one
  input = File.read 'data/day_02_input.txt'
  red_december = Submarine.new
  red_december.set_course input
  
  pos, depth = red_december.pos, red_december.depth

  "The final horizontal position (#{pos}) multiplied by the final depth (#{depth}) equals #{pos * depth}."
end

def solution_to_part_two
  input = File.read 'data/day_02_input.txt'
  red_december = AimingSubmarine.new
  red_december.set_course input
  
  pos, depth = red_december.pos, red_december.depth

  "The final horizontal position (#{pos}) multiplied by the final depth (#{depth}) equals #{pos * depth}."
end

puts "Day 2: Dive!"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
