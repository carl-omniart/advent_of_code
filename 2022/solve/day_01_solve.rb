require 'day_01'

def solution_to_part_one
  input     = File.read 'data/day_01_input.txt'
  food_list = FoodList.parse input
  this_many = food_list.max_calories
  
  "The number of calories carried by the Elf carrying the most calories is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_01_input.txt'
  food_list = FoodList.parse input
  this_many = food_list.max_calories 3
  
  "The number of calories carried by the three Elves carrying the most calories is #{this_many}."
end

puts "Day 1: Calorie Counting"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
