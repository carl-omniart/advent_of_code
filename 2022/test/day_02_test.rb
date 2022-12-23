require 'minitest/autorun'
require 'day_02'

class RockPaperScissorsTest < Minitest::Test
  INPUT = %Q(
    A Y
    B X
    C Z
  )
  
  def test_score
    strategy_guide = RockPaperScissors.parse INPUT
    score          = strategy_guide.my_score
    expected_score = 15
    assert_equal expected_score, score
  end
  
  def test_updated_score
    strategy_guide = RockPaperScissors.parse INPUT, updated: true
    score          = strategy_guide.my_score
    expected_score = 12
    assert_equal expected_score, score
  end
end
