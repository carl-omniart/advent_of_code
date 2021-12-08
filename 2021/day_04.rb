class Bingo
  def initialize input
    input = StringIO.new(input).readlines.map &:strip

    @numbers = input.shift.split(",").map &:to_i
    
    grids = []

    input.each do |line|
      if line == ""
        grids << []
      else
        grids.last << line.split(" ").map(&:to_i)
      end
    end
    
    @boards  = grids.map { |grid| Board.new *grid }
    @winners = []
  end
  
  attr_reader :boards
  attr_reader :winners
  
  def play!
    until @numbers.empty?
      call_number
      break if winners_check
    end
  end
  
  def play_to_lose!
    until @numbers.empty? || boards.empty?
      call_number
      winners_check
    end
  end
  
  def winners_check
    new_winners, @boards = boards.partition &:bingo?
    if new_winners.empty?
      false
    else
      @winners << new_winners
      true
    end
  end
  
  def call_number
    called_number = @numbers.shift
    boards.each { |board| board.mark called_number }
  end
  
  def winners
    @winners.first
  end
  
  def losers
    return nil unless @boards.empty?
    @winners.last
  end
end
  
class Board
  def initialize *rows
    @rows   = rows
    @marked = []
  end
  
  attr_reader :rows

  def columns
    rows.transpose
  end
  
  def each_row_and_column
    [*rows, *columns].each { |set| yield set }
  end
  
  attr_reader :marked
  
  def numbers
    @rows.flatten
  end
  
  def mark called_number
    @marked << called_number if numbers.include? called_number
  end
  
  def unmarked
    numbers - marked
  end
  
  def unmarked_sum
    unmarked.sum
  end
   
  def last_marked
    marked.last
  end
  
  def bingo?
    each_row_and_column { |set| return true if (set - marked).empty? }
    false
  end
  
  def score
    return nil unless self.bingo?
    unmarked_sum * last_marked
  end
end

file_path = Dir.pwd + "/day_04_input.txt"
input = File.read(file_path)

game = Bingo.new input
game.play!
winner = game.winners.first

puts "1. Multiplying the sum of unmarked numbers on the winning board (#{winner.unmarked_sum}) by the number that was just called (#{winner.last_marked}) equals a score of #{winner.score}."

game.play_to_lose!
loser = game.losers.last

puts "2. Multiplying the sum of unmarked numbers on the losing board (#{loser.unmarked_sum}) by the number that was just called (#{loser.last_marked}) equals a score of #{loser.score}."


