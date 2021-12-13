require_relative 'day_13.rb'

file_path = Dir.pwd + "/day_13_input.txt"
input     = File.read file_path

paper = TransparentPaper.new input
paper.fold
count = paper.visible_dot_count

puts "1. The number of dots visible after one fold is #{count}."

paper.fold_all
puts "2."
puts paper.visible_dots
