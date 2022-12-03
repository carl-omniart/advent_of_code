class FoodList
  def self.parse input
    list = input.strip.split("\n").map(&:strip).reduce([[]]) do |list, item|
    	item == nil.to_s ? list << [] : list.last << item.to_i
    	list
    end
    
    self.new *list
  end
  
  def initialize *list
  	@food_list = list
  end
  
  attr_reader :food_list
  
  def calorie_counts
  	food_list.map &:sum
  end
  
  def max_calories n = 1
  	calorie_counts.max(n).sum
  end
end
