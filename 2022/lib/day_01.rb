module CalorieCounting
  class << self
    def get_elves string
      parse(string).map do |inventory|
        food_items = inventory.map { |calories| FoodItem.new calories }
        Elf.new *food_items
      end
    end

    def parse string
      string.gsub(/[^\S\n]/, '').split("\n\n").map do |lines|
        lines.split("\n").map &:to_i
      end
    end
  end
      
  class FoodItem
    def initialize calories
      self.calories = calories
    end
    
    attr_accessor :calories
  end
  
  class Elf
    def initialize *food_items
      self.food_items = food_items
    end
    
    attr_accessor :food_items
    
    def total_calories
      food_items.map(&:calories).sum
    end
  end
end
