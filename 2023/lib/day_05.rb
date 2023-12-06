module IfYouGiveASeedAFertilizer
  class SetAlmanac
    def self.parse string
      seed_section, *map_sections = clean(string).split("\n\n")
      
      self.new do |almanac|
        each_seed(seed_section) { |seed| almanac.seeds << seed }
        each_map(*map_sections) { |map|  almanac.maps  <<  map }
      end
    end
    
    def self.clean string
      string.strip.split("\n").map(&:strip).join("\n")
    end
    
    def self.each_seed string
      Set.parse(string).each { |seed| yield seed }
    end
    
    def self.each_map *strings
      Map.parse(*strings).each { |map| yield map }
    end
    
    def initialize
      @seeds = []
      @maps  = []
      yield self if block_given?
    end
    
    attr_reader :seeds
    attr_reader :maps

    def locations
      seeds.map do |seed|
        maps.reduce(seed) { |item, map| map * item }
      end
    end
  end
  
  class ObjectAlmanac < SetAlmanac
    def self.each_seed string
      Object.parse(string).each { |seed| yield seed }
    end
  end

  class Set
    def self.parse string
      category, body = string.split /s:\s+/
      numbers        = body.scan(/\d+/).map &:to_i
      
      each_range(numbers).map do |range|
        self.new(category) { |set| set.ranges << range }
      end
    end
    
    def self.each_range numbers
      return enum_for(:each_range, numbers) unless block_given?
      numbers.each_slice(2) { |start, length| yield Range.new(start, length) }
    end
    
    def initialize category
      @category = category
      @ranges   = []
      yield self if block_given?
    end
    
    attr_reader :category
    attr_reader :ranges
    
    def min
      ranges.map { |range| range.start }.min
    end
  end

  class Object < Set
    def self.each_range numbers
      return enum_for(:each_range, numbers) unless block_given?
      numbers.each { |start| yield Range.new(start, 1) }
    end
  end
  
  class Range
    def self.create start, stop
      length = stop - start + 1
      length.positive? ? self.new(start, length) : nil
    end
    
    def initialize start, length
      @start  = start
      @length = length
    end
    
    attr_reader :start
    attr_reader :length
    
    def stop
      start + length - 1
    end
    
    def shift this_much
      self.class.new(start + this_much, length)
    end
    
    def < other
      self.class.create start, [stop, other.start - 1].min
    end
    
    def & other
      self.class.create [start, other.start].max, [stop, other.stop].min
    end
    
    def > other
      self.class.create [start, other.stop + 1].max, stop
    end
  end
  
  class Map
    def self.parse *strings
      strings.map do |string|
        head, body          = string.split /:\s*/
        source, destination = head.gsub(/ map$/, "").split "-to-"
        rules               = body.split("\n").map { |line| Rule.parse line }
        
        self.new(source, destination) { |map| map.add *rules }
      end
    end
    
    def initialize source, destination
      @source      = source
      @destination = destination
      @rules       = []
      yield self if block_given?
    end
    
    attr_reader :source
    attr_reader :destination
    attr_reader :rules
    
    def add *rules
      (@rules += rules).sort_by! { |r| r.source.start }
      self
    end
    
    def * item
      raise ArgumentError, "nice try, bub" unless item.category == source
      
      item.class.new(destination) do |new_item|
        item.ranges.each do |range|
          rules.each do |rule|
            break if range.nil?
            left, intersection, right = rule * range
            new_item.ranges << left if left
            new_item.ranges << intersection if intersection
            range = right
          end
          new_item.ranges << range if range
          
        end
      end
    end
  end
  
  class Rule
    def self.parse string
      destination_start, source_start, length = string.scan(/\d+/).map &:to_i
      self.new destination_start, source_start, length
    end
    
    def initialize destination_start, source_start, length
      @source      = Range.new source_start, length
      @destination = Range.new destination_start, length
    end
    
    attr_reader :source
    attr_reader :destination
    
    def adjustment
      destination.start - source.start
    end
    
    def * range
      left         = range < source
      intersection = range & source
      right        = range > source
      
      intersection = intersection.shift(adjustment) if intersection
      
      [left, intersection, right]
    end
  end
end