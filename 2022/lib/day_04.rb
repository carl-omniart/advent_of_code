module CampCleanup
  class << self
    def parse string
      range_pairs = stripped_lines(string).map { |line| parse_range_pair line }
      range_pairs.map { |range_pair| SectionAssignments.new *range_pair }
    end
    
    def stripped_lines string
      string.strip.split("\n").map { |line| line.strip }
    end
    
    def parse_range_pair line
      line.split(",").map { |string| parse_range string }
    end
    
    def parse_range string
      Range.new *string.split("-").map(&:to_i)
    end
  end
  
  class SectionAssignments
    def initialize *ranges
      @ranges = ranges
    end
  
    attr_reader :ranges
  
    def fully_contained?
      ranges.permutation(2).any? { |a, b| a.cover? b }
    end
    
    def separate?
      ranges.combination(2).all? { |a, b| (a.to_a & b.to_a).empty? }
    end
    
    def overlap?
      !separate?
    end
  end
end