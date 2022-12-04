class Rucksack
	PRIORITY = (("a".."z").to_a + ("A".."Z").to_a).zip((1..54).to_a).to_h
	
	def self.parse input
		lines = input.strip.split("\n").map { |line| line.strip.chars }
		lines.map { |items| self.new items }
	end
	
	def initialize items
		count = items.size
		half  = count / 2
		
		@compartments = [items[0...half], items[half...count]]
	end
	
	attr_reader :compartments
	
	def common_items
		compartments.inject &:&
	end
	
	def common_items_priority
		common_items.map { |item| PRIORITY[item] }.sum
	end
	
	def items
		@compartments.flatten
	end
end

class ElfGroup
	def initialize *rucksacks
		@rucksacks = rucksacks
	end
	
	attr_reader :rucksacks
	
	def badge
		rucksacks.map(&:items).inject(&:&).first
	end
	
	def badge_priority
		Rucksack::PRIORITY[badge]
	end
end
		

