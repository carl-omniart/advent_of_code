require 'day_05'

def solution_to_part_one
  input     = File.read 'data/day_05_input.txt'
  vents     = Vent.parse(input).select { |v| v.vertical? || v.horizontal? }
  diagram   = Diagram.new *vents
  this_many = diagram.dangerous_area_count
  
  "The number of points where at least two lines overlap is #{this_many}."
end

def solution_to_part_two
  input     = File.read 'data/day_05_input.txt'
  vents     = Vent.parse input
  vents.select! { |v| v.vertical? || v.horizontal? || v.diagonal? }
  diagram   = Diagram.new *vents  
  this_many = diagram.dangerous_area_count

  "The number of points where at least two lines overlap is #{this_many}."
end

puts "Day 5: Hydrothermal Venture"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
