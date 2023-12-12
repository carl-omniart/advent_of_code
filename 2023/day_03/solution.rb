module Day03
  class << self
    def title
      'Gear Ratios'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Schematic.parse(input).part_numbers.map(&:value).sum
    end
    
    def solve_part_two input
      Schematic.parse(input).gears.map(&:gear_ratio).sum
    end
  end
  
  class Schematic
    class << self
      def parse string
        self.new do |schematic|
          lines = string.split "\n"
          lines.each_with_index do |line, top|
            Object.parse_each(line, top) { |object| schematic.add object }
          end
        end
      end
    end
    
    def initialize
      @objects = []
      @by_row  = Hash.new { |hash, y| hash[y] = [] }
      @by_col  = Hash.new { |hash, x| hash[x] = [] }
      yield self if block_given?
    end
    
    attr_reader :objects
    
    def add object
      set_neighbors object
      set_index object
      objects << object
      self
    end
    
    def part_numbers
      objects.select &:part_number?
    end
    
    def gears
      objects.select &:gear?
    end
    
    private
    
    attr_reader :by_row
    attr_reader :by_col
    
    def set_index object
      object.top.upto(object.bottom) { |y| by_row[y] << object }
      object.left.upto(object.right) { |x| by_col[x] << object }
    end
    
    def set_neighbors object
      neighbors(object).each { |neighbor| object.introduce neighbor }
    end
    
    def neighbors object
      row_neighbors(object) & col_neighbors(object)
    end
    
    def row_neighbors object
      rows = (object.top - 1)..(object.bottom + 1)
      rows.map { |y| by_row[y] }.reduce(:|) - [object]
    end
    
    def col_neighbors object
      cols = (object.left - 1)..(object.right + 1)
      cols.map { |x| by_col[x] }.reduce(:|) - [object]
    end
  end
  
  class Object
    class << self
      def parse_each line, top
        subclasses.each do |klass|
          klass.parse_each(line, top) { |object| yield object }
        end
      end
    end
    
    def initialize value, top, left
      @value     = value
      @top       = top
      @left      = left
      @neighbors = []
    end
    
    attr_reader :value
    attr_reader :top
    attr_reader :left
    attr_reader :neighbors
    
    def size
      value.to_s.size
    end
    
    alias_method :bottom, :top
    
    def right
      left + size - 1
    end
    
    def introduce neighbor
      neighbor.neighbors << self
      self.neighbors     << neighbor
      self
    end
    
    def part_number?
      false
    end
    
    def gear?
      false
    end
  end
  
  class Number < Object
    class << self
      def parse_each line, top
        line.enum_for(:scan, /\d+/).each do |num|
          value, left = num.to_i, Regexp.last_match.begin(0)
          yield self.new(value, top, left)
        end
      end
    end
    
    def part_number?
      neighbors.any? { |neighbor| neighbor.is_a? Symbol }
    end
  end
  
  class Symbol < Object
    class << self
      def parse_each line, top
        line.enum_for(:scan, /[^\d\.]/).each do |sym|
          value, left = sym.to_sym, Regexp.last_match.begin(0)
          yield self.new(value, top, left)
        end
      end
    end
    
    def number_neighbors
      neighbors.select { |neighbor| neighbor.is_a? Number }
    end

    def gear?
      value == :'*' && number_neighbors.size == 2
    end
    
    def gear_ratio
      return nil unless gear?
      number_neighbors.map(&:value).reduce :*
    end
  end
end
