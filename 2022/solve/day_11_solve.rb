require 'day_11'

def solution_to_part_one
  input = File.read 'data/day_11_input.txt'
  troop = MonkeyInTheMiddle.parse input
  troop.do_rounds 20
  troop.monkey_business
end

def solution_to_part_two
  input = File.read 'data/day_11_input.txt'
  troop = MonkeyInTheMiddle.parse input
  troop.do_rounds 10_000, relief: false
  troop.monkey_business
end

puts "Day 11: Monkey in the Middle"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
