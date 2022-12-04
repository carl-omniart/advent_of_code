class Game
	WHAT_DEFEATS = {
		rock:			:paper,
		paper:		:scissors,
		scissors:	:rock
	}
	
	POINTS = {
		rock: 		1,
		paper: 		2,
		scissors: 3,
		lose:			0,
		draw:			3,
		win:			6
	}
	
	def initialize player_1, player_2
		@players = [player_1, player_2]
		@scores  = [0, 0]
	end
	
	attr_reader :players	
	attr_reader :scores
	
	def play!
		shapes = players.map(&:shoot!).tap { |shapes| score_shapes shapes }
		
		compare(*shapes).tap { |outcome| score_outcome outcome }
	end
			
	private
	
	def compare shape_1, shape_2
		return [:lose,  :win] if WHAT_DEFEATS[shape_1] == shape_2
		return [:draw, :draw] if shape_1 == shape_2
		return [ :win, :lose] if WHAT_DEFEATS[shape_2] == shape_1
		raise StandardError, "What game are you playing?"
	end
	
	def score_shapes shapes
		add_points shapes.map { |shape| POINTS[shape] }
	end
	
	def score_outcome outcome
		add_points outcome.map { |result| POINTS[result] }
	end
	
	def add_points points
		@scores = scores.zip(points).map &:sum
	end
end

class AutoPlayer
	def initialize play_list
		@play_list = play_list
	end
	
	attr_reader :play_list
	
	def shoot!
		play_list.shift
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

		def parse input
			guide = input.strip.split("\n").map { |line| decrypt line.strip.split(" ") }
		
			self.new guide
		end
	
		def decrypt line
			line.map { |char| code[char] }
		end
  end
	
	def initialize guide
		@players = guide.transpose.map { |play_list| AutoPlayer.new play_list }
	end
	
	attr_reader :players
	
	def calculate_scores
		game = Game.new *players
		game.play! until players.first.play_list.empty?
		game.scores
	end
	
	def calculate_my_score
		calculate_scores.last
	end
end

class SonOfStrategyGuide < StrategyGuide
	@code = {
		"A" => :rock,
		"B" => :paper,
		"C" => :scissors,
		"X" => :lose,
		"Y" => :draw,
		"Z" => :win
	}		

	class << self
		def decrypt line
			line = super line
		
			shapes    = [:rock, :paper, :scissors]
			rotate_by = { lose: 2, draw: 0, win: 1 }
			
			n       = shapes.index(line.first) + rotate_by[line.last]
			line[1] = shapes.rotate(n).first
		
			line
		end
	end
end
