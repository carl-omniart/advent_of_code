require 'minitest/autorun'

require_relative 'day_04.rb'

class BoardTest < Minitest::Test
  def test_marking_numbers
    board_1 = Board.new [22, 13, 17, 11,  0],
                        [ 8,  2, 23,  4, 24],
                        [21,  9, 14, 16,  7],
                        [ 6, 10,  3, 18,  5],
                        [ 1, 12, 20, 15, 19]

    board_2 = Board.new [ 3, 15,  0,  2, 22],
                        [ 9, 18, 13, 17,  5],
                        [19,  8,  7, 25, 23],
                        [20, 11, 10, 24,  4],
                        [14, 21, 16, 12,  6]

    board_3 = Board.new [14, 21, 17, 24,  4],
                        [10, 16, 15,  9, 19],
                        [18,  8, 23, 26, 20],
                        [22, 11, 13,  6,  5],
                        [ 2,  0, 12,  3,  7]
                        
    boards = [board_1, board_2, board_3]

    boards.each { |board| assert_equal false, board.bingo? }
    
    numbers = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21]
    numbers.each do |number|
      boards.each do |board|
        board.mark number
        assert_equal false, board.bingo?
      end
    end
    
    boards.each { |board| board.mark 24 }
    assert_equal false, board_1.bingo?
    assert_equal false, board_2.bingo?
    assert_equal true, board_3.bingo?    
  end
  
  def test_scoring_winner
    board = Board.new [14, 21, 17, 24,  4],
                      [10, 16, 15,  9, 19],
                      [18,  8, 23, 26, 20],
                      [22, 11, 13,  6,  5],
                      [ 2,  0, 12,  3,  7]
    assert_nil board.score

    numbers = [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24]
    
    numbers.each { |number| board.mark number }
    assert_equal 4512, board.score
  end
end

class BingoTest < Minitest::Test
  def test_game_play
    input = <<~EOS
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
       8  2 23  4 24
      21  9 14 16  7
       6 10  3 18  5
       1 12 20 15 19

       3 15  0  2 22
       9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
       2  0 12  3  7
    EOS
    
    game = Bingo.new input
    game.play!
    winner = game.winners.first
    
    assert_equal 4512, winner.score
    
    game = Bingo.new input
    game.play_to_lose!
    loser = game.losers.last
    
    assert_equal 1924, loser.score
  end
end
