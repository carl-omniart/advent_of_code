require 'day_09'

def solution_to_part_one
  input = File.read 'data/day_09_input.txt'
  steps = RopeBridge.parse input
  rope  = RopeBridge::Rope.new 2
  steps.each { |dir, n| rope.move dir, n }
  rope.log(2).uniq.size
end

def solution_to_part_two
  input = File.read 'data/day_09_input.txt'
  steps = RopeBridge.parse input
  rope  = RopeBridge::Rope.new 10
  steps.each { |dir, n| rope.move dir, n }
  rope.log(10).uniq.size
end

puts "Day 9: Rope Bridge"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
