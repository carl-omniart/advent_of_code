module RopeBridge
  class << self
    def parse string
      stripped_lines(string).map do |line|
        dir, n = line.split(" ")
        [dir, n.to_i]
      end
    end
    
    def stripped_lines string
      string.strip.split("\n").map &:strip
    end
  end
  
  class Rope
    VECTOR = {
      "U" => [ 0,  1],
      "R" => [ 1,  0],
      "D" => [ 0, -1],
      "L" => [-1,  0]
    }
    
    def initialize knot_count
      @knots = knot_count.times.map { [0, 0] }
      @log   = []
    end
    
    attr_reader :knots
    
    def log knot = nil
      knot ? @log.transpose[knot - 1] : @log
    end
    
    def head
      knots.first
    end
    
    def move dir, n
      n.times do
        move_head VECTOR[dir]
        move_tail
        log_position
      end
    end
    
    def move_head vector
      head.replace add(head, vector)
    end
    
    def move_tail
      knots.each_cons(2) do |leader, follower|
        distance = subtract leader, follower
        if distance.any? { |d| d.abs >= 2 }
          vector = distance.map { |d| d <=> 0 }
          follower.replace add(follower, vector)
        end
      end
    end
    
    def log_position
      log << knots.map(&:dup)
    end
    
    def add *coords
      coords.transpose.map &:sum
    end
    
    def subtract *coords
      coords.transpose.map { |c| c.reduce :- }
    end
  end
end