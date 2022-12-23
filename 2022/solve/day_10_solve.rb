require 'day_10'

def solution_to_part_one
  input   = File.read 'data/day_10_input.txt'
  program = CathodeRayTube.parse input
  cpu     = CathodeRayTube::CPU.new *program
  cpu.interesting_signal_strengths.sum
end

def solution_to_part_two
  input   = File.read 'data/day_10_input.txt'
  program = CathodeRayTube.parse input
  cpu     = CathodeRayTube::CPU.new *program
  cpu.screen.join("\n     ")
end

puts "Day 10: Cathode-Ray Tube"
puts "  1. #{solution_to_part_one}"
puts "  2. #{solution_to_part_two}"
