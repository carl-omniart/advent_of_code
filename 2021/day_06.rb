class Lanternfish
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

file_path = Dir.pwd + "/day_06_input.txt"
input     = File.read(file_path).strip.split(",").map &:to_i

fish = Lanternfish.new *input
fish.age_until 80

puts "1. After 80 days, there are #{fish.count} fish in the school."

fish.age_until 256

puts "2. After 256 days, there are #{fish.count} fish in the school."
