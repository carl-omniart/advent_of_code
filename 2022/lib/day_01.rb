module CalorieCounting
	class << self
		def parse string
			string = strip_whitespace_except_new_lines string
			each_elf(string).to_a
		end
			
		def strip_whitespace_except_new_lines string
			string.strip.gsub /[^\S\n]/, ''
		end
		
		def each_elf string
			return enum_for(:each_elf, string) unless block_given?
			string.strip.split("\n\n").each { |lines| yield to_elf(lines) }
		end
	
		def to_elf lines
			food_items = each_food_item(lines).to_a
			Elf.new *food_items
		end
		
		def each_food_item lines
			return enum_for(:each_food_item, lines) unless block_given?
			lines.split("\n").each { |line| yield to_food_item(line) }
		end	
		
		def to_food_item line
			calories = line.to_i
			FoodItem.new calories
		end
	end
	
	class FoodItem
		def initialize calories
			@calories = calories
		end
		
		attr_reader :calories
	end
	
	class Elf
		def initialize *food_items
			@food_items = food_items
		end
		
		attr_reader :food_items
		
		def calories
			food_items.map &:calories
		end
		
		def total_calories
			calories.sum
		end
	end
end
