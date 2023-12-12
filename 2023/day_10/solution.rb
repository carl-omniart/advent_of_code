module Day10
  class << self
    def title
      'Pipe Maze'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Maze.parse(input).furthest_steps_from_starting_position
    end
    
    def solve_part_two input
      Maze.parse(input).enclosed_tiles.size
    end
  end
    
  class Direction
    @instances = []
    
    class << self
      attr_reader :instances

      def new *args
        super(*args).tap { |dir| instances << dir }
      end
    end
    
    def initialize name, dx, dy
      @name = name
      @dx   = dx
      @dy   = dy
    end
    
    attr_reader :name
    attr_reader :dx
    attr_reader :dy
    
    def to_s
      name
    end
    
    def inspect
      "<#{self.class}: #{name}>"
    end
    
    def vector
      [dx, dy]
    end
    
    def == other
      name == other.name
    end
    
    def opposite
      self.class.instances.find { |dir| dx == -dir.dx && dy == -dir.dy }
    end
        
    def vertical?
      dy != 0
    end
  end
  
  class Object
    def initialize char
      @char = char
      yield self if block_given?
    end
    
    attr_reader :char
    
    def inspect
      "<#{self.class}: #{char}>"
    end
  end
  
  class Ground < Object; end
  
  class Pipe < Object
    def initialize char, *directions
      super char
      @directions = directions
    end
    
    attr_accessor :directions
  end
  
  class Maze
    DIRECTIONS = [
      Direction.new(:north,  0, -1),
      Direction.new(:south,  0,  1),
      Direction.new( :east,  1,  0),
      Direction.new( :west, -1,  0)
    ].map { |dir| [dir.name, dir] }.to_h
    
    OBJECTS = [
      Pipe.new(  "|", *DIRECTIONS.values_at(:north, :south)),
      Pipe.new(  "-", *DIRECTIONS.values_at( :east,  :west)),
      Pipe.new(  "L", *DIRECTIONS.values_at(:north,  :east)),
      Pipe.new(  "J", *DIRECTIONS.values_at(:north,  :west)),
      Pipe.new(  "7", *DIRECTIONS.values_at(:south,  :west)),
      Pipe.new(  "F", *DIRECTIONS.values_at(:south,  :east)),
      Pipe.new(  "S"),
      Ground.new(".")
    ].map { |object| [object.char, object] }.to_h
    
    class << self
      def parse string
        self.new do |maze|
          lines = string.split "\n"
          lines.each { |line| maze.tiles << parse_line(line) }
        end
      end
      
      def parse_line string
        string.each_char.map { |char| OBJECTS[char] }
      end
    end
    
    def initialize
      @tiles = []
      yield self if block_given?
    end
    
    attr_reader :tiles
    
    def length
      tiles.size
    end
    
    def width
      tiles.first.size
    end
    
    def tile_exists? x, y
      x.between?(0, width - 1) && y.between?(0, length - 1)
    end
    
    def object_at x, y
      return nil unless tile_exists?(x, y)
      tiles[y][x]
    end
    
    def starting_position
      x = nil
      y = tiles.index do |row|
        x = row.index { |object| object.char == "S" }
      end
      [x, y]
    end
    
    def directions_of_connecting_pipes x, y
      DIRECTIONS.each_value.select do |heading|
        neighbor    = object_at x + heading.dx, y + heading.dy
        coming_from = heading.opposite
        neighbor.is_a?(Pipe) && neighbor.directions.include?(coming_from)
      end
    end
    
    def set_starting_position
      starting_position.tap do |x, y|
        starting_tile = object_at x, y
        starting_tile.directions = directions_of_connecting_pipes x, y
      end
    end
    
    def run_loop
      x, y          = set_starting_position
      starting_tile = object_at x, y
      rand_heading  = starting_tile.directions.shuffle.first
      
      Runner.new(self, [x, y], rand_heading).run_loop
    end

    def furthest_steps_from_starting_position
      run_loop.steps / 2
    end
    
    def enclosed_tiles
      runner    = run_loop
      path      = runner.tiles.sort_by { |x, y| [y, x] }.uniq
      x1, y1    = nil, nil
      vert_dirs = DIRECTIONS.values.select &:vertical?
      flag      = vert_dirs.map { |dir| [dir, false] }.to_h
      enclosed = []
      
      until path.empty?
        x2, y2 = path.shift
        (x1 + 1).upto(x2 - 1) { |x| enclosed << [x, y1] } if flag.values.all?
        
        directions = object_at(x2, y2).directions.select &:vertical?
        directions.each { |dir| flag[dir] = !flag[dir] }
        x1, y1 = x2, y2
      end
      
      enclosed
    end
  end
  
  class Runner
    def initialize maze, pos, heading
      @maze     = maze
      @tiles    = [pos]
      @headings = [heading]
    end
    
    attr_reader :maze
    attr_reader :tiles
    attr_reader :headings
    
    def pos
      tiles.last
    end
    
    def steps
      tiles.size
    end
    
    def heading
      headings.last
    end
    
    def starting_position?
      pos == tiles.first
    end
    
    def take_step
      tiles << pos.zip(heading.vector).map(&:sum)
      
      pipe         = maze.object_at *pos
      entrance     = heading.opposite

      headings << pipe.directions.find { |dir| dir != entrance }
      
      self
    end
    
    def run_loop
      take_step until starting_position? && steps > 1 
      self
    end
  end
end
