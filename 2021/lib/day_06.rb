class Lanternfish
  def self.parse input
    fish = input.strip.split(",").map &:to_i
    self.new *fish
  end
  
  def initialize *fish
    @days = 0
    @fish = 0.upto(8).map { |n| fish.count n }
  end
  
  def age number_of_days = 1
    1.upto(number_of_days) do
      @fish.rotate!
      @fish[6] += @fish[8]
      @days += 1
    end
    self
  end
  
  def age_until days
    number_of_days = days - @days
    age number_of_days
  end
  
  def count
    @fish.sum
  end
end
