module CubeConundrum
  def self.parse_games string
    stripped_lines(string).map do |line|
      header, body = line.split(": ")
      id   = header.match(/Game (\d+)/)[1]
      sets = body.split("; ").map do |item|
        item.split(", ").map do |cubes|
          quantity, color = cubes.split " "
          quantity = quantity.to_i
          color    = color.to_sym
          [color, quantity]
        end.to_h
      end
      
      Game.new(id).add *sets
    end
  end
  
  def self.stripped_lines string
    string.strip.split("\n").map &:strip
  end
  
  class Game
    def initialize id
      @id   = id.to_i
      @sets = []
    end
    
    attr_reader :id
    attr_reader :sets
    
    def add *new_sets
      new_sets.each { |new_set| sets << new_set }
      self
    end
    
    def maxes
      {}.merge(*sets) { |key, *vals| vals.max }
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
    
    def possible_draw? set
      set.all? { |color, quantity| cubes[color] >= quantity }
    end
    
    def possible_game? game
      game.sets.all? { |set| possible_draw? set }
    end
  end
end