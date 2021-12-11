require_relative 'day_10.rb'

file_path = Dir.pwd + "/day_10_input.txt"
input     = File.readlines(file_path).map &:strip

syntax = Syntax.new *input
sum    = syntax.total_syntax_error_score

puts "1. The total syntax error score is #{sum}."

median = syntax.median_needed_closers_score

puts "2. The middle score for the scored completion strings is #{median}."
