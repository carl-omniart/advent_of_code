module Day01
  class << self
    def title
      'Trebuchet?!'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
  
    def solve_part_one input
      Document.line = Line
      Document.parse(input).calibration_values.sum
    end
  
    def solve_part_two input
      Document.line = WordyLine
      Document.parse(input).calibration_values.sum
    end
  end

  class Document
    class << self
      attr_accessor :line
      
      def parse string
        lines = string.split("\n").map { |str| line.parse str }
        self.new *lines
      end
    end

    def initialize *lines
      @lines = lines
    end
    
    attr_reader :lines
    
    def calibration_values
      lines.map &:calibration_value
    end
  end
  
  class Line
    class << self
      def parse string
        calibration_value = digits_in(string).values_at(0, -1).join.to_i
        self.new calibration_value
      end
      
      def digits_in string
        string.scan /\d/
      end
    end
    
    def initialize calibration_value
      @calibration_value = calibration_value
    end
    
    attr_reader :calibration_value
  end
  
  class WordyLine < Line
    WORDS = %w(one two three four five six seven eight nine).map.with_index(1).to_h
    
    class << self
      def digits_in string
        digits_and_words_in(string).map { |item| WORDS[item] || item }
      end
      
      def digits_and_words_in string
        string.scan(/(?=(#{(WORDS.keys << "\\d").join("|")}))/).flatten
      end
    end
  end
end
