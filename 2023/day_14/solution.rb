module Day14
  class << self
    def title
      'Parabolic Reflector Dish'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Grid.parse(input).tilt!(:north).total_load
    end
    
    def solve_part_two input
      Grid.parse(input).spin_cycle!(1_000_000_000).total_load
    end
  end
  
  class Grid
    DIRECTIONS = {
      north: [   :rotate_180,    :rotate_180],
      west:  [  :rotate_left,  :rotate_right],
      south: [:do_not_rotate, :do_not_rotate],
      east:  [ :rotate_right,   :rotate_left]
    }
    
    class << self
      def parse input
        lines   = input.split "\n"
        columns = lines.map(&:chars).transpose
        self.new *columns
      end
      
      def roll columns
        columns.map do |column|
          column.slice_before("#").map { |span| span.sort }.flatten
        end
      end
      
      def rotate_left ary
        ary.transpose.map &:reverse
      end
      
      def rotate_right ary
        ary.transpose.reverse
      end
      
      def rotate_180 ary
        ary.reverse.map &:reverse
      end
      
      def do_not_rotate ary
        ary
      end
    end
    
    def initialize *columns
      @columns = columns
    end
    
    def initialize_dup original
      self.columns = original.columns.map &:dup
      self
    end
    
    attr_accessor :columns
    
    def rows
      columns.transpose
    end
    
    def cycle
      @cycle ||= get_cycle
    end
    
    def == other
      columns == other.columns
    end
    
    def to_s
      rows.map { |row| row.join }
    end
    
    def rotate direction, &function
      rotate, unrotate = DIRECTIONS[direction]
      rotated_columns  = function.call self.class.send(rotate, columns)
      self.class.send unrotate, rotated_columns
    end
    
    def tilt! direction
      self.columns = rotate(direction) { |cols| self.class.roll cols }
      self
    end
    
    def spin_cycle! times = 1
      periodic_equivalent(times).times { cycle! }
      self
    end
    
    def cycle!
      DIRECTIONS.each_key { |direction| tilt! direction }
      self
    end
    
    def periodic_equivalent times
      (times - cycle[:start]) % cycle[:period] + cycle[:start]
    end
    
    def total_load
      rows.reverse.each.with_index(1).reduce(0) do |total, (row, load)|
        total + row.count("O") * load
      end
    end
    
    private
    
    def get_cycle
      tortoise = dup.cycle!
      hare     = dup.cycle!.cycle!
      
      until tortoise == hare
        tortoise.cycle!
        hare.cycle!.cycle!
      end
      
      start    = 0
      tortoise = dup

      until tortoise == hare
        tortoise.cycle!
        hare.cycle!
        start += 1
      end
      
      period  = 1
      hare    = tortoise.dup.cycle!
      
      until tortoise == hare
        hare.cycle!
        period += 1
      end
      
      { start: start, period: period }
    end
  end
end