module Day11
  class << self
    def title
      'Cosmic Expansion'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Cosmos.expansion_factor = 2
      cosmos = Cosmos.parse(input).expand!
      cosmos.shortest_paths.sum
    end
    
    def solve_part_two input, expansion_factor = 1_000_000
      Cosmos.expansion_factor = expansion_factor
      cosmos = Cosmos.parse(input).expand!
      cosmos.shortest_paths.sum
    end
  end
  
  class Cosmos
    class << self
      attr_accessor :expansion_factor
      
      def parse string
        lines = string.split "\n"
        self.new do |cosmos|
          lines.each_with_index do |line, y|
            line.each_char.with_index do |char, x|
              cosmos.galaxies << Galaxy.new(x, y) if char == "#"
            end
          end
        end
      end
      
      def each_galaxy line, y
        line.each_char.with_index do |char, x|
          yield Galaxy.new(x, y) if char == "#"
        end
      end
    end
    
    def initialize
      @galaxies = []
      yield self if block_given?
    end
    
    attr_reader :galaxies
    
    def row_index
      galaxies.group_by &:y
    end
    
    def col_index
      galaxies.group_by &:x
    end
    
    def expand!
      [:y, :x].each do |coord|
        index            = galaxies.group_by { |galaxy| galaxy.send coord }
        with_galaxies    = index.keys.sort
        first, last      = with_galaxies.first, with_galaxies.last
        all              = (first..last).to_a
        without_galaxies = all - with_galaxies
        
        without_galaxies.reverse.each do |spaaace|
          expanding = with_galaxies.select{ |occupied| occupied > spaaace } 
          expanding.each do |occupied|
            index[occupied].each do |galaxy|
              new_value = galaxy.send(coord) + self.class.expansion_factor - 1
              galaxy.send :"#{coord}=", new_value
            end
          end
        end
      end
      
      self
    end
    
    def shortest_paths
      galaxies.combination(2).map { |a, b| (a.y - b.y).abs + (a.x - b.x).abs }
    end
  end
  
  class Galaxy
    @next_id = 1
    
    class << self
      attr_accessor :next_id
      
      def get_id
        next_id.tap { self.next_id += 1 }
      end
    end
        
    def initialize x, y
      @id = self.class.get_id
      @x  = x
      @y  = y
    end
    
    attr_reader :id
    
    attr_accessor :x
    attr_accessor :y
  end
end
