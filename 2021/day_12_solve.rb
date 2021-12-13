require_relative 'day_12.rb'

file_path = Dir.pwd + "/day_12_input.txt"
input     = File.read file_path

caves = CaveSystem.new input
count = caves.paths_that_visit_no_small_cave_twice.size

puts "1. The number of unique paths through the cave system that do not visit a small cave more than once is #{count}."

count = caves.paths_that_visit_one_small_cave_twice.size

puts "2. The number of unique paths through the cave system that do not visit more than one small cave twice is #{count}."
