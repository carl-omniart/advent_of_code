require 'day_06'

def solution_to_part_one
  input = File.read 'data/day_06_input.txt'
  races = WaitForIt::Race.parse input
  boat  = WaitForIt::Boat.new
  races.map { |race| race.ways_to_beat_record boat }.reduce :*
end

def solution_to_part_two
  input = File.read 'data/day_06_input.txt'
  race  = WaitForIt::OneRace.parse input
  boat  = WaitForIt::Boat.new
  race.ways_to_beat_record boat
end


puts "Day 6: Wait For It"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
