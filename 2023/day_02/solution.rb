module Day02
  class << self
    def title
      'CubeConundrum'
    end
  
    def day
      name.gsub('Day', '').to_i
    end
  
    def puzzle_input
      File.read 'input.txt'
    end
  
    def solve_part_one input
      lines = input.split "\n"
      games = lines.map { |line| Game.parse line }
      bag   = Bag.new red: 12, green: 13, blue: 14
      games.select { |game| bag.possible_game? game }.map(&:id).sum
    end
  
    def solve_part_two input
      lines = input.split "\n"
      games = lines.map { |line| Game.parse line }
      bags  = games.map { |game| Bag.new **game.maxes }
      bags.map(&:power).sum
    end
    
    def parse string
      string.split("\n").map { |line| Game.parse line }
    end
  end
  
  class Game
    class << self
      def parse string
        header, body = string.split ": "
        id           = header.match(/Game (?<id>\d+)/)[:id].to_i
        draws        = parse_draws body
        self.new id, *draws
      end
      
      def parse_draws string
        string.split("; ").map { |str| parse_cubes str }
      end
      
      def parse_cubes string
        string.split(", ").map { |str| parse_cube(str) }.to_h
      end
      
      def parse_cube string
        count, color = string.split " "
        [color.to_sym, count.to_i]
      end
    end
    
    def initialize id, *draws
      @id    = id
      @draws = draws
    end
    
    attr_reader :id
    attr_reader :draws
    
    def maxes
      {}.merge(*draws) { |key, *vals| vals.max }
    end
  end
  
  class Bag
    def initialize red: 0, green: 0, blue: 0
      @cubes = { red: red, green: green, blue: blue }
    end
    
    attr_reader :cubes
    
    def power
      cubes.each_value.reduce :*
    end
    
    def possible_draw? draw
      draw.all? { |color, quantity| cubes[color] >= quantity }
    end
    
    def possible_game? game
      game.draws.all? { |draw| possible_draw? draw }
    end
  end
end
