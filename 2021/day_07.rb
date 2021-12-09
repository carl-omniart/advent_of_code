class Crabs
  def initialize *positions
    @crabs = positions
  end
  
  def fuel_cost position
    @crabs.map { |pos| (position - pos).abs }.sum
  end
  
  def fuel_costs
    @crabs.min.upto(@crabs.max).map { |position| fuel_cost position }
  end
  
  def lowest_fuel_cost
    fuel_costs.min
  end
  
  def lowest_fuel_position
    costs = fuel_costs
    costs.index costs.min
  end
end

class NewCrabs < Crabs
  def fuel_cost position
    @crabs.map { |pos| (position - pos).abs }.map { |n| n * (n + 1) / 2 }.sum
  end
end

file_path = Dir.pwd + "/day_07_input.txt"
input     = File.read(file_path).strip.split(",").map &:to_i

cost = Crabs.new(*input).lowest_fuel_cost

puts "1. The least amount of fuel needed to align is #{cost}."

cost = NewCrabs.new(*input).lowest_fuel_cost

puts "2. The least amount of fuel needed to align is #{cost}."
