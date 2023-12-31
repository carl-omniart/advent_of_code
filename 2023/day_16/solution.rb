module Day16
  class << self
    def title
      'The Floor Will Be Lava'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      contraption = Contraption.parse input
      beam        = Beam.new [-1, 0], :right
      contraption.energize!(beam).energized_tiles
    end
    
    def solve_part_two input
      contraption = Contraption.parse input
      tiles       = contraption.each_possible_beam.map do |beam|
                      contraption.energize!(beam).energized_tiles
                    end
      tiles.max
    end
  end
  
  class Contraption
    class << self
      def parse input
        lines = input.split "\n"
        grid  = Grid.new height: lines.size, width: lines.first.size
        
        lines.each_with_index do |line, y|
          line.each_char.with_index do |char, x|
            pos       = [x, y]
            object    = Object.parse char
            grid[pos] = object if object
          end
        end
        
        self.new grid
      end
    end
    
    def initialize grid
      @grid = grid
      reset_path
    end
    
    attr_reader :grid
    attr_reader :path
    
    def reset_path
      @path = Grid.new(height: grid.height, width: grid.width) { [] }
      self
    end
    
    def energize! *beams
      reset_path
      
      until beams.empty?
        beam = beams.shift.move!
        next unless grid.covers? beam.pos
        
        next if path[beam.pos].include? beam.char
        path[beam.pos] << beam.char
        
        object = grid[beam.pos]
        
        if object
          beam.dir, split_dir = object.new_dir beam.dir
          beams << Beam.new(beam.pos, split_dir) if split_dir
        end
          
        beams << beam
      end
      
      self
    end
    
    def energized_tiles
      path.items.count &:any?
    end
    
    def each_possible_beam
      return enum_for(:each_possible_beam) unless block_given?
      w, h = grid.width, grid.height
      0.upto(w - 1)     { |x| yield Beam.new([ x, -1],  :down) }
      0.upto(h - 1)     { |y| yield Beam.new([ w,  y],  :left) }
      (w - 1).downto(0) { |x| yield Beam.new([ x,  h],    :up) }
      (h - 1).downto(0) { |y| yield Beam.new([-1,  y], :right) }
    end
    
    def beam_to_s
      path.rows.map do |row|
        row.map do |cell|
          case cell.size
          when 0
            "."
          when 1
            cell.first
          else
            cell.size.to_s
          end
        end.join
      end.join("\n")
    end
    
    def energized_tiles_to_s
      path.rows.map do |row|
        row.map { |cell| cell.any? ? "#" : "." }.join
      end.join("\n")
    end
  end
  
  class Grid
    def initialize height:, width:, &default_block
      @rows = Array.new(height) { Array.new width, &default_block }
    end
    
    attr_reader :rows
    
    def height
      rows.size
    end
    
    def width
      rows.first.size
    end
    
    def to_s
      rows.map { |row| row.map { |val| val ? val.to_s : "." }.join }.join "\n"
    end
    
    def covers? pos
      x, y = pos
      x.between?(0, width - 1) && y.between?(0, height - 1)
    end
    
    def [] pos
      x, y = pos
      rows[y][x]
    end
    
    def []= pos, item
      x, y = pos
      rows[y][x] = item
    end
    
    def items
      rows.flatten(1).compact
    end
  end

  class Beam
    CHARS = {
      up:     "^",
      down:   "v",
      right:  ">",
      left:   "<"
    }
    
    VECTORS = {
      up:     [ 0, -1],
      down:   [ 0,  1],
      right:  [ 1,  0],
      left:   [-1,  0]
    }
    
    def initialize pos, dir
      self.pos = pos
      self.dir = dir
    end
    
    attr_accessor :pos
    attr_accessor :dir
    
    def vector
      VECTORS[dir]
    end
    
    def char
      CHARS[dir]
    end
    
    def move!
      self.pos = pos.zip(vector).map &:sum
      self
    end
  end
    
  class Object
    class << self
      attr_reader :char
      attr_reader :directions
      
      def descendents
        subclasses.reduce([]) { |ary, sc| ary |= [sc, *sc.descendents] }
      end
      
      def parse char
        klass = descendents.find { |klass| char == klass.char }
        return nil unless klass
        klass.new
      end
    end
    
    def char
      self.class.char
    end
    
    alias_method :to_s, :char
    
    def new_dir dir
      self.class.directions[dir]
    end
  end
  
  class Mirror < Object; end
  
  class ForwardMirror < Mirror
    @char = "/"
    
    @directions = {
      up:    :right,
      down:   :left,
      right:    :up,
      left:   :down
    }
  end
  
  class BackMirror < Mirror
    @char = "\\"
    
    @directions = {
      up:     :left,
      down:  :right,
      right:  :down,
      left:     :up
    }
  end
  
  class Splitter < Object; end
  
  class VerticalSplitter < Splitter
    @char = "|"
    
    @directions = {
      up:     :up,
      down:   :down,
      right:  [:up, :down],
      left:   [:up, :down]
    }
  end
  
  class HorizontalSplitter < Splitter
    @char = "-"
    
    @directions = {
      up:     [:right, :left],
      down:   [:right, :left],
      right:  :right,
      left:   :left
    }
  end
end
