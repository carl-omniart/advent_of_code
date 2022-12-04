require 'minitest/autorun'
require 'day_02'

class StrategyGuideTest < Minitest::Test
  INPUT = %Q(
  	A Y
    B X
    C Z
  )
  
  def test_calculate_my_scores
  	guide = StrategyGuide.parse INPUT
  	assert_equal 15, guide.calculate_my_score
  end
  
  def test_son_of_calculate_my_scores_
  	guide = SonOfStrategyGuide.parse INPUT
  	assert_equal 12, guide.calculate_my_score
  end
end
