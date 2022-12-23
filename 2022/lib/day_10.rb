module CathodeRayTube
  class << self
    def parse string
      stripped_lines(string).map { |line| line.split " " }
    end
    
    def stripped_lines string
      string.strip.split("\n").map &:strip
    end
  end
  
  class CPU
    DEFAULTS = {
      height:       6,
      width:       40,
      lit_pixel:  "#",
      dark_pixel: "."
    }
    
    def initialize *instructions, **options
      options = DEFAULTS.merge options
      
      self.height     = options[:height]
      self.width      = options[:width]
      self.lit_pixel   = options[:lit_pixel]
      self.dark_pixel = options[:dark_pixel]
      
      @screen  = blank_screen
      @cycles  = [1]
      
      instructions.each do |instruction|
        command, *args = instruction
        self.send(command, *args)
      end
    end
    
    attr_accessor :height
    attr_accessor :width
    attr_accessor :lit_pixel
    attr_accessor :dark_pixel

    attr_reader :screen
    attr_reader :cycles
    
    def blank_screen
      height.times.map { dark_pixel * width }
    end
    
    def x
      cycles.last
    end
    
    def sprite
      ((x - 1)..(x + 1))
    end

    def ticks
      cycles.size - 1
    end
    
    def row
      (ticks / 40) % height
    end
    
    def col
      ticks % 40
    end
    
    def visible_sprite?
      sprite.cover? col
    end
    
    def increment new_x
      draw
      cycles << new_x
    end
    
    def draw
      screen[row][col] = visible_sprite? ? lit_pixel : dark_pixel
    end
    
    def noop *args
      increment x
    end
    
    def addx *args
      value = args.first.to_i
      increment x
      increment (x + value)
    end
    
    def interesting_signal_strengths
      each_interesting_cycle.map { |c| c * cycles[c - 1] }
    end
        
    def each_interesting_cycle
      return enum_for(:each_interesting_cycle) unless block_given?
      n = -20
      yield n while cycles[n += 40]
    end    
  end
end