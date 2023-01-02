module RockPaperScissors
  class Game
    WHAT_DEFEATS_WHAT = {
      rock:     :scissors,
      paper:    :rock,
      scissors: :paper
    }
  
    POINTS = {
      rock:     1,
      paper:    2,
      scissors: 3,
      loss:     0,
      draw:     3,
      win:      6
    }
  
    def initialize player_1, player_2
      self.players = [player_1, player_2]
      self.rounds  = []
    end
    
    attr_accessor :players  
    attr_accessor :rounds
    
    def shapes
      WHAT_DEFEATS_WHAT.keys
    end
    
    def get_outcome shape_1, shape_2
      return [ :win, :loss] if WHAT_DEFEATS_WHAT[shape_1] == shape_2
      return [:draw, :draw] if shape_1 == shape_2
      return [:loss,  :win] if WHAT_DEFEATS_WHAT[shape_2] == shape_1
      raise StandardError, "What game are you playing?"
    end
    
    def get_score shape_or_outcome
      POINTS[shape_or_outcome]
    end
    
    def play_round!
      round = Round.new self
      round.play!
      rounds << round
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
      self.game = game
    end
    
    attr_accessor :game
    attr_accessor :shapes
    
    def players
      game.players
    end

    attr_accessor :outcome
    attr_accessor :score
    
    def play!
      self.shapes = players.map { |player| player.choose! }
      self
    end
    
    def outcome
      game.get_outcome *shapes
    end
    
    def score
      shape_score.zip(outcome_score).map &:sum
    end
    
    def shape_score
      shapes.map { |shape| game.get_score shape }
    end
    
    def outcome_score
      outcome.map { |result| game.get_score result }
    end
  end
  
  class ProgrammedPlayer
    def initialize *choices
      self.choices = choices
    end
    
    attr_accessor :choices
    
    def choose!
      choices.shift
    end
    
    def done?
      choices.empty?
    end
  end

  class StrategyGuide
    CODE = {
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :rock,
      "Y" => :paper,
      "Z" => :scissors
    }
  
    class << self
      def parse string
        lines       = string.strip.split("\n").map &:strip
        predictions = lines.map { |line| line.split " " }
        self.new *predictions
      end
    end
    
    def initialize *predictions
      self.predictions = predictions.map { |prediction| decrypt prediction }
    end
    
    attr_accessor :predictions
    
    def decrypt prediction
      prediction.map { |char| CODE[char] }
    end
    
    def programmed_players
      predictions.transpose.map { |choices| ProgrammedPlayer.new *choices }
    end
    
    def simulate_game
      you, me = programmed_players
      Game.new(you, me).tap { |game| game.play_round! until you.done? }
    end
  end
  
  class UpdatedStrategyGuide < StrategyGuide
    CODE = {
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :loss,
      "Y" => :draw,
      "Z" => :win
    }
    
    def decrypt prediction
      your_shape, result = prediction.map { |char| CODE[char] }
      my_shape           = case result
                           when :win
                            Game::WHAT_DEFEATS_WHAT.invert[your_shape]
                           when :draw
                            your_shape
                           when :loss
                            Game::WHAT_DEFEATS_WHAT[your_shape]
                           end
      [your_shape, my_shape]
    end
  end
end