require 'day_19'

def solution_to_part_one region_map
  this_many   = region_map.beacon_count
  "The full map has #{this_many} beacons."
end

def solution_to_part_two region_map
  distance = region_map.manhattan_distances.max
  
  "The largest Manhattan distance between any two scanners is #{distance}."
end

puts "Day 19: Beacon Scanner"

input       = File.read 'data/day_19_input.txt'
region_map  = RegionMap.parse input

puts "1. #{solution_to_part_one(region_map)}"
puts "2. #{solution_to_part_two(region_map)}"
puts
