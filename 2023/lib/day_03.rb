module GearRatios
  class Schematic
    def self.parse string
      lines = string.strip.split("\n").map &:strip
      self.new do |schematic|
        lines.each_with_index do |line, row|
          each_line_object(line, row) { |object| schematic.add object }
        end
      end
    end
    
    def self.each_line_object line, row
      Object.subclasses.each do |type|
        line.enum_for(:scan, type.regexp).each do
          match = Regexp.last_match
          value = match.to_s
          col   = match.begin 0
          yield type.new(value, row, col)
        end
      end
    end
    
    def initialize
      @objects = []
      @by_row  = Hash.new { |hash, row| hash[row] = [] }
      @by_col  = Hash.new { |hash, col| hash[col] = [] }
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
      by_row[object.row] << object
      object.cols.each { |col| by_col[col] << object }
    end
    
    def set_neighbors object
      neighbors(object).each { |neighbor| object.add_neighbor neighbor }
    end
    
    def neighbors object
      row_neighbors(object) & col_neighbors(object)
    end
    
    def row_neighbors object
      range = (object.row - 1)..(object.row + 1)
      range.map { |row| by_row[row] }.reduce(:|) - [object]
    end
    
    def col_neighbors object
      range = (object.col_start - 1)..(object.col_end + 1)
      range.map { |col| by_col[col] }.reduce(:|) - [object]
    end
  end
  
  class Object
    def initialize value, row, col
      self.value = value
      @row       = row
      @col       = col
      @neighbors = []
    end
    
    attr_accessor :value
    attr_accessor :row
    attr_accessor :col
    
    attr_reader :neighbors
    
    def to_s
      value.to_s
    end
    
    alias_method :inspect, :to_s
    
    alias_method :col_start, :col
    
    def col_end
      col_start + to_s.size - 1
    end
    
    def cols
      (col_start..col_end).to_a
    end
    
    def add_neighbor neighbor
      neighbor.neighbors << self
      self.neighbors     << neighbor
    end
    
    def part_number?
      false
    end
    
    def gear?
      false
    end
  end
  
  class Number < GearRatios::Object
    def self.regexp
      /\d+/
    end
    
    def value= val
      @value = val.to_i
    end
    
    def part_number?
      neighbors.any? { |nabr| nabr.is_a? Symbol }
    end
  end
  
  class Symbol < GearRatios::Object
    def self.regexp
      /[^\.\d]/
    end
    
    def gear?
      value == "*" && neighbors.count { |nabr| nabr.is_a? Number } == 2
    end
    
    def gear_ratio
      return nil unless gear?
      neighbors.select { |nabr| nabr.is_a? Number }.map(&:value).reduce :*
    end
  end
end