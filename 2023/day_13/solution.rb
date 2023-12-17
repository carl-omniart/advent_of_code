module Day13
  class << self
    def title
      'Point of Incidence'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Valley.parse(input).summary
    end
    
    def solve_part_two input
      SmudgedValley.parse(input).summary
    end
  end
  
  class Pattern
    class << self
      def parse input
        rows = input.split "\n"
        self.new *rows
      end
      
      def line_of_symmetry rows
        0.upto(rows.size - 2).find { |i| reflects? rows, i }
      end
      
      def reflects? rows, i
        front, back = divide rows, i
        front.zip(back).all? { |a, b| a == b }
      end
      
      def divide rows, i
        len   = [i + 1, rows.size - (i + 1)].min
        front = rows[i - len + 1, len].reverse
        back  = rows[i       + 1, len]
        [front, back]
      end
      
      def unreflected rows
        i = line_of_symmetry rows
        i ? i + 1 : 0
      end
    end
    
    def initialize *rows
      @rows = rows
    end
    
    attr_reader :rows
    
    def columns
      rows.map(&:chars).transpose.map &:join
    end
    
    def upper_rows
      self.class.unreflected rows
    end
    
    def left_columns
      self.class.unreflected columns
    end
  end
  
  class SmudgedPattern < Pattern
    class << self
      def reflects? rows, i
        front, back = divide rows, i
        expected    = [0] * (front.size - 1) + [1]
        front.zip(back).map { |a, b| differences a, b }.sort == expected
      end
      
      def differences a, b
        a.chars.zip(b.chars).count { |aa, bb| aa != bb }
      end
      
      def unreflected rows
        i     = line_of_symmetry rows
        old_i = Pattern.line_of_symmetry rows
        return 0 if i == old_i
        i ? i + 1 : 0
      end
    end
  end
  
  class Valley
    @pattern = Pattern
    
    class << self
      attr_reader :pattern
      
      def parse input
        patterns = input.split("\n\n").map { |rows| pattern.parse rows }
        self.new *patterns
      end
    end
    
    def initialize *patterns
      @patterns = patterns
    end
    
    attr_reader :patterns
    
    def summary
      patterns.map(&:left_columns).sum + 100 * patterns.map(&:upper_rows).sum
    end
  end
  
  class SmudgedValley < Valley
    @pattern = SmudgedPattern
  end
end
