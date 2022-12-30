module RockPaperScissors
  class << self
    def parse string, updated: false
      predictions = stripped_lines(string).map { |line| line.split " " }
      guide = updated ? UpdatedStrategyGuide : StrategyGuide
      guide.new *predictions
    end
    
    def stripped_lines string
      string.strip.split("\n").map { |line| line.strip }
    end
  end
  
  class Game
    @what_defeats_what = {
      rock:     :scissors,
      paper:    :rock,
      scissors: :paper
    }
  
    @points = {
      rock:     1,
      paper:    2,
      scissors: 3,
      loss:     0,
      draw:     3,
      win:      6
    }
  
    class << self
      attr_accessor :what_defeats_what
      attr_accessor :points
      
      def what_is_defeated_by_what
        what_defeats_what.invert
      end
      
      def outcome shape_1, shape_2
        return [ :win, :loss] if what_defeats_what[shape_1] == shape_2
        return [:draw, :draw] if shape_1 == shape_2
        return [:loss,  :win] if what_is_defeated_by_what[shape_1] == shape_2
        raise StandardError, "What game are you playing?"
      end
      
      def score shape_or_outcome
        points[shape_or_outcome]
      end
    end
  
    def initialize player_1, player_2
      @players = [player_1, player_2]
      @rounds  = []
    end
    
    attr_reader :players  
    attr_reader :rounds
    
    def play_round!
      rounds << Round.new(self)
      self
    end
    
    def outcomes
      rounds.map &:outcome
    end
    
    def scores
      rounds.map &:score
    end
          
    def score
      scores.transpose.map &:sum
    end
  end

  class Round
    def initialize game
      @game    = game
      @shapes  = players.map &:shoot!
    end
    
    attr_reader :game
    attr_reader :shapes
    
    def players
      game.players
    end
    
    def outcome
      game.class.outcome *shapes
    end
    
    def shapes_score
      shapes.map { |shape| game.class.score shape }
    end
    
    def outcome_score
      outcome.map { |result| game.class.score result }
    end
    
    def score
      shapes_score.zip(outcome_score).map &:sum
    end
  end

  class Player
    def initialize *shapes
      @shapes = shapes
    end
  
    attr_reader :shapes
  
    def shoot!
      shapes.shift
    end
    
    def done?
      shapes.empty?
    end
  end

  class StrategyGuide
    @code = {
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :rock,
      "Y" => :paper,
      "Z" => :scissors
    }
  
    class << self
      attr_reader :code
      
      def decrypt *predictions
        predictions.map { |round| round.map { |player| code[player] } }
      end  
    end
    
    def initialize *predictions
      @predictions = predictions
    end
    
    attr_reader :predictions
    
    def decrypted_predictions
      self.class.decrypt *predictions
    end
    
    def score
      game = Game.new *players
      game.play_round! until game.players.first.done?
      game.score
    end
    
    def my_score
      score.last
    end      
    
    private
    
    def players
      decrypted_predictions.transpose.map { |shapes| Player.new *shapes }
    end
  end
  
  class UpdatedStrategyGuide < StrategyGuide
    @code = {
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :loss,
      "Y" => :draw,
      "Z" => :win
    }
    
    class << self
      def decrypt *predictions
        super(*predictions).map do |shape_1, result|
          shape_2 = case result
                    when :win
                      Game.what_is_defeated_by_what[shape_1]
                    when :draw
                      shape_1
                    when :loss
                      Game.what_defeats_what[shape_1]
                    end
          [shape_1, shape_2]
        end
      end
    end
  end
end