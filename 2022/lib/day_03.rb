module RucksackReorganization
	ITEMS = {}
	
	class << self
		def parse string
			stripped_lines(string).map do |line|
				items = line.each_char.map { |char| ITEMS[char] }
				Rucksack.new *items
			end
		end

		def stripped_lines string
			string.strip.split("\n").map { |line| line.strip }
		end
		
		def group *rucksacks
			rucksacks.each_slice(3).map { |sacks| ElfGroup.new *sacks }
		end
	end
	
	class Item
		def initialize char, priority
			@char 		= char
			@priority = priority
		end
		
		attr_reader :char
		attr_reader :priority
	end
	
	class Rucksack
		def initialize *items
			count = items.size
			half  = count / 2
		
			@compartments = [items[0...half], items[half...count]]
		end
	
		attr_reader :compartments
		
		def items
			compartments.flatten
		end
	
		def common_items
			compartments.inject &:&
		end
	
		def priorities_of_common_items
			common_items.map &:priority
		end
		
		def common_item_priority
			priorities_of_common_items.sum
		end	
	end

	class ElfGroup
		def initialize *rucksacks
			@rucksacks = rucksacks
		end
	
		attr_reader :rucksacks
		
		def common_items
			rucksacks.map(&:items).inject &:&
		end
	
		def badge
			common_items.first
		end
	
		def badge_priority
			badge.priority
		end
	end
	
 	("a".."z").each_with_index { |char, i| ITEMS[char] = Item.new(char, i +  1) }
	("A".."Z").each_with_index { |char, i| ITEMS[char] = Item.new(char, i + 27) }
end
