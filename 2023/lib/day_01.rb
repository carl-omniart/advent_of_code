module Trebuchet
  class Document
    def self.parse string
      clean_strings = string.strip.split("\n").map &:strip      
      self.new { |doc| doc.add *clean_strings }
    end

    def initialize
      @lines = []
      @words = false
      yield self if block_given?
    end
    
    attr_reader :lines
    attr_accessor :words
    
    def add *strings
      strings.each { |string| lines << Line.new(string) }
      self
    end
    
    def values
      lines.map { |line| line.value(words: words) }
    end
    
    def sum
      values.sum
    end    
  end
  
  class Line
    WORDS = %w(
      one two three four five six seven eight nine
    ).map.with_index(1).to_h
    
    def initialize string
      @string = string
    end
    
    attr_reader :string
    
    def digits
      string.scan /\d/
    end
    
    def digits_and_words
      regex = "(?=(#{(WORDS.keys << "\\d").join("|")}))"
      string.scan(/#{regex}/).flatten.map { |chars| WORDS[chars] || chars }
    end
    
    def value words: false
      (words ? digits_and_words : digits).values_at(0, -1).join.to_i
    end
  end
end
