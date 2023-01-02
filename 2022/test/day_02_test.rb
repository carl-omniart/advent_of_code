require 'minitest/autorun'
require 'day_02'

class RockPaperScissorsTest < Minitest::Test
  INPUT = %Q(
    A Y
    B X
    C Z
  )
  
  def test_score
    guide          = RockPaperScissors::StrategyGuide.parse INPUT
    score          = guide.simulate_game.score.last
    expected_score = 15
    assert_equal expected_score, score
  end
  
  def test_updated_score
    guide          = RockPaperScissors::UpdatedStrategyGuide.parse INPUT
    score          = guide.simulate_game.score.last
    expected_score = 12
    assert_equal expected_score, score
  end
end
