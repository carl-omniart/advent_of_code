class Crabs
  def self.parse input
    positions = input.strip.split(",").map &:to_i
    self.new *positions
  end
  
  def initialize *positions
    @crabs = positions
  end
  
  attr_reader :crabs
  
  def left
    crabs.min
  end
  
  def right
    crabs.max
  end    
  
  def fuel_cost position
    crabs.map { |pos| (position - pos).abs }.sum
  end
  
  def fuel_costs
    @costs || (left.upto(right).map { |position| fuel_cost position })
  end
  
  def lowest_fuel_cost
    fuel_costs.min
  end
  
  def lowest_fuel_position
    fuel_costs.index lowest_fuel_cost
  end
end

class NewCrabs < Crabs
  def fuel_cost position
    crabs.map { |pos| (position - pos).abs }.map { |n| n * (n + 1) / 2 }.sum
  end
end
