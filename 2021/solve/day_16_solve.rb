require 'day_16'

def solution_to_part_one
  transmission  = File.read 'data/day_16_input.txt'
  packet        = Packet.parse_hex transmission
  sum           = packet.version_sum

  "The sum of the version numbers of all packets is #{sum}."
end

def solution_to_part_two
  transmission  = File.read 'data/day_16_input.txt'
  packet        = Packet.parse_hex transmission
  value         = packet.value
  
  "The value of the expression represented by the hexadecimal-encoded BITS transmission is #{value}."
end

puts "Day 16: Packet Decoder"
puts "1. #{solution_to_part_one}"
puts "2. #{solution_to_part_two}"
puts
