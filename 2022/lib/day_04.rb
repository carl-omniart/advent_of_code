class SectionAssignments
	def self.parse input
		range_pairs = input.strip.split("\n").map { |pair| parse_pair pair.strip }
		range_pairs.map { |ranges| self.new *ranges }
	end
	
	def self.parse_pair string_pair
		string_pair.split(",").map { |range| parse_range range }
	end
	
	def self.parse_range string_range
		Range.new *string_range.split("-").map(&:to_i)
	end
	
	def initialize *ranges
		@ranges = ranges
	end
	
	attr_reader :ranges
	
	def fully_contained?
		ranges.permutation(2).any? { |a, b| a.cover? b }
	end
	
	def overlap?
		ranges.combination(2).any? { |a, b| !(a.to_a & b.to_a).empty? }
	end
end
