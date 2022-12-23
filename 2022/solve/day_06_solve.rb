require 'day_06'

def solution_to_part_one
  signal = File.read 'data/day_06_input.txt'
  device = TuningTrouble::HandheldDevice.new
  device.lock_on_to(signal).start_of_packet_marker_position
end

def solution_to_part_two
  signal = File.read 'data/day_06_input.txt'
  device = TuningTrouble::HandheldDevice.new
  device.lock_on_to(signal).start_of_message_marker_position
end

puts "Day 6: Tuning Trouble"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
