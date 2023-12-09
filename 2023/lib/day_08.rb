module HauntedWasteland
  class Map
    def self.parse string
      head, body = string.split "\n\n"
      directions = parse_directions head
      lines      = body.split "\n"
      nodes      = lines.map { |line| Node.parse line }

      self.new directions, *nodes
    end
    
    def self.parse_directions string
      string.each_char.map { |char| char == "L" ? :left : :right }
    end
    
    def initialize directions, *nodes
      @directions = directions
      @nodes        = nodes.map { |node| [node.name, node] }.to_h
    end
    
    attr_reader :directions
    attr_reader :nodes
    
    def period
      directions.size
    end
    
    def steps_between start_node_name, end_node_name
      steps  = 0
      degree = 0
      name   = start_node_name
      
      while true
        break if name == end_node_name
        
        name   = nodes[name].send directions[degree]
        steps += 1
        degree = steps % period
      end
      
      steps
    end
    
    def ghost_syzygy
      start_names = nodes.each_key.select { |name| name.end_with? "A" }
      syzygies    = start_names.map { |name| get_syzygy name }
      syzygies.reduce(:+).first_point
    end
    
    def get_syzygy name
      steps  = 0
      degree = 0
      cycle  = Array.new(period) { [] }
      points = []
      
      while true
        break if cycle[degree].include? name

        cycle[degree] << name
        points        << steps if name.end_with? "Z"
        name           = nodes[name].send directions[degree]
        steps         += 1
        degree         = steps % period
      end
      
      offset = cycle[degree].index(name) * period + degree
      
      Syzygy.new(offset, steps - offset) do |syzygy|
        points.each { |point| syzygy.add point }
      end
    end
  end
  
  class Node
    def self.parse line
      values = line.match /(?<name>\w+) = \((?<left>\w+), (?<right>\w+)\)/
      name, left, right = values.values_at(:name, :left, :right).map &:to_sym
      self.new name, left, right
    end
    
    def initialize name, left, right
      @name  = name
      @left  = left
      @right = right
    end
    
    attr_reader :name
    attr_reader :left
    attr_reader :right
  end
  
  class Syzygy
    def initialize offset, period
      @offset        = offset
      @period        = period
      @offset_points = []
      @cycle_degrees = []
      yield self if block_given?
    end
    
    attr_reader :offset
    attr_reader :period
    attr_reader :offset_points
    attr_reader :cycle_degrees
    
    def period_end
      offset + period - 1
    end
    
    def spacing
      period / cycle_degrees.size
    end
    
    def first_point
      return offset_points.first unless offset_points.empty?
      return nil if cycle_degrees.empty?
      to_point 0, cycle_degrees.first
    end
    
    def add point
      if point < offset
        raise ArgumentError, "Don't be negative" if point.negative?
        offset_points << point
      else
        raise ArgumentError, "Far out, dude" unless to_cycle(point).zero?
        cycle_degrees << to_degree(point)
      end
      self
    end
    
    def to_point cycle, degree
      offset + (period * cycle) + degree
    end
    
    def to_cycle point
      return nil if point < offset
      (point - offset) / period
    end
    
    def to_degree point
      return nil if point < offset
      (point - offset) % period
    end
    
    def include? point
      return offset_points.include?(point) if point < offset
      cycle_degrees.include? to_degree(point)
    end
    
    def each_point_by_cycle first, last = nil
      return enum_for(:each_point_by_cycle, first, last) unless block_given?
      last = first unless last
      first.upto(last) do |cycle|
        cycle_degrees.each { |degree| yield to_point(cycle, degree) }
      end
    end
    
    def each_point_between first, last
      return enum_for(:each_point_between, first, last) unless block_given?
      if first < offset
        offset_points.each { |point| yield point if point.between? first, last }
      end
      if last >= offset
        each_point_by_cycle(to_cycle(first) || 0, to_cycle(last)) do |point|
          yield point if point.between? first, last
        end
      end
    end
    
    def + other
      new_offset = [offset, other.offset].max
      new_period = period.lcm other.period
      
      self.class.new(new_offset, new_period) do |syzygy|
        dense, sparse = [self, other].sort_by &:spacing
        sparse.each_point_between(0, syzygy.period_end) do |point|
          syzygy.add(point) if dense.include? point
        end
      end
    end
  end
end
