class Bingo
  def self.parse input
    input = input.strip.split("\n").map &:strip
    
    numbers = input.shift.split(",").map &:to_i
    
    boards = [].tap do |ary|
      input.each do |line|
        if line == ""
          board = []
          ary << board
        else
          board = ary.last
          board << line.split(" ").map(&:to_i)
        end
      end
    end
    
    self.new numbers, boards
  end
  
  def initialize numbers, boards
    @numbers  = numbers
    @boards   = boards.map { |board| Board.new board }
    @bingos   = []
  end
  
  attr_reader :boards
  attr_reader :bingos
  
  def winner?
    bingos.empty? == false
  end
  
  def loser?
    boards.empty?
  end
  
  def winners
    winner? ? bingos.first : nil
  end
  
  def losers
    loser? ? bingos.last : nil
  end
  
  def call_number
    called_number = @numbers.shift
    boards.each { |board| board.mark called_number }
  end
  
  def check_for_bingos
    new_bingos, @boards = boards.partition &:bingo?
    @bingos << new_bingos unless new_bingos.empty?
    new_bingos
  end
  
  def play!
    until @numbers.empty?
      call_number
      check_for_bingos
      break if winner?
    end
    winners
  end
  
  def play_to_lose!
    until @numbers.empty?
      call_number
      check_for_bingos
      break if loser?
    end
    losers
  end
end
  
class Board
  def initialize rows
    @rows   = rows
    @marked = []
  end
  
  attr_reader :rows
  attr_reader :marked

  def columns
    rows.transpose
  end
  
  def each_row_and_column
    return enum_for(:each_row_and_column) unless block_given?
    [*rows, *columns].each { |set| yield set }
  end
  
  def numbers
    rows.flatten
  end
  
  def mark number
    numbers.include?(number).tap { |bool| @marked << number if bool }
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
    each_row_and_column.any? { |set| (set - marked).empty? }
  end
  
  def score
    bingo? ? unmarked_sum * last_marked : nil
  end
end
