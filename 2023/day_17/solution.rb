module Day17
  class << self
    def title
      'Clumsy Crucible'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Graph.min_times = 1
      Graph.max_times = 3
      Map.parse(input).minimum_heat_loss
    end
    
    def solve_part_two input
      Graph.min_times = 4
      Graph.max_times = 10
      Map.parse(input).minimum_heat_loss
    end
  end
  
  class Map
    class << self
      def parse input
        rows = input.split("\n").map { |line| line.each_char.map(&:to_i) }
        self.new Graph.new(*rows)
      end
    end
    
    def initialize graph
      @graph = graph
    end
    
    attr_reader :graph
    
    def minimum_heat_loss
      rightward = [0, 0, 1, Graph.min_times]
      downward  = [0, 0, 2, Graph.min_times]
      distance  = 0
      termini   = [ [*rightward, distance], [*downward, distance] ]
      
      until termini.empty?
        *indices, distance = termini.shift
        return distance if graph.finish? *indices
        
        vertex = graph.get *indices
        next if vertex.visited?
        vertex.visited!
        
        graph.each_connection(*indices) do |*new_indices, weight|
          new_vertex  = graph.get *new_indices
          new_d       = distance + weight
          new_vertex.distance = new_d if new_d < new_vertex.distance
          at_i = termini.bsearch_index { |a| a.last >= new_d } || termini.size
          termini.insert at_i, [*new_indices, new_d]
        end
      end

      nil
    end
  end
  
  class Graph
    @vectors = [
      [ 0, -1],
      [ 1,  0],
      [ 0,  1],
      [-1,  0]
    ]
    
    @min_times = 1
    @max_times = 3
    
    class << self
      attr_reader :vectors
      
      attr_accessor :min_times
      attr_accessor :max_times
    end
    
    def initialize *rows
      @x_range  = (0..(rows.first.size - 1))
      @y_range  = (0..(rows.size - 1))
      @v_range  = (0..(self.class.vectors.size- 1))
      @t_range  = (self.class.min_times..self.class.max_times)
      @graph    = make_nested_array *dimensions
      
      rows.each_with_index do |row, y|
        row.each_with_index do |weight, x|
          each_state { |v, t| set x, y, v, t, Vertex.new(weight) }
        end
      end
    end
    
    attr_reader :x_range
    attr_reader :y_range
    attr_reader :v_range
    attr_reader :t_range
    
    def dimensions
      [x_range, y_range, v_range, t_range]
    end
    
    def include? x, y, v, t
      [x, y, v, t].zip(dimensions).all? { |i, range| range.cover? i }
    end
    
    def finish? x, y, v, t
      x == x_range.max && y == y_range.max
    end
    
    def get x, y, v, t
      return nil unless include? x, y, v, t
      graph[x][y][v][t - t_range.min]
    end
    
    def values_at *indices
      indices.map { |x, y, v, t| get x, y, v, t }
    end
    
    def set x, y, v, t, value
      graph[x][y][v][t - t_range.min] = value
    end
    
    def each_connection x, y, v, t
      return enum_for(:each_connection, x, y, v, t) unless block_given?

      left_and_right(v).each do |(dx, dy), new_v|
        stretch = []
        t_range.each do |new_t|
          new_x   = x + dx * new_t
          new_y   = y + dy * new_t
          indices = [new_x, new_y, new_v, new_t]
          break unless include? *indices
          
          weight  = 1.upto(new_t).reduce(0) do |w, dt|
                      xx = x + dx * dt
                      yy = y + dy * dt
                      w + get(xx, yy, new_v, t_range.min).weight
                    end

          yield *indices, weight
        end
      end
    end
    
    private
    
    attr_reader :graph
    
    def make_nested_array *dimensions
      range, *rest = dimensions
      Array.new(range.size) do
        rest.empty? ? nil : make_nested_array(*rest)
      end
    end
    
    def each_state
      return enum_for(:each_state) unless block_given?
      v_range.each { |v| t_range.each { |t| yield v, t } }
    end
    
    def left_and_right v
      self.class.vectors.each_with_index.to_a.rotate(v).values_at 1, 3
    end
  end
  
  class Vertex
    def initialize weight
      @weight   = weight
      @visited  = false
      @distance = Float::INFINITY
    end
    
    attr_accessor :weight
    attr_accessor :distance
    
    def visited?
      @visited
    end
    
    def visited!
      @visited = true
    end
  end
end
