require 'day_01'

def solution_to_part_one
  input    = File.read 'data/day_01_input.txt'
  document = Trebuchet::Document.parse input
  document.sum
end

def solution_to_part_two
  input          = File.read 'data/day_01_input.txt'
  document       = Trebuchet::Document.parse input
  document.words = true
  document.sum
end

puts "Day 1: Trebuchet?!"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
