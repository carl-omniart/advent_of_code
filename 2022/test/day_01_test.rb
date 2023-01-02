require 'minitest/autorun'
require 'day_01'

class CalorieCountingTest < Minitest::Test
  INPUT = %Q(
    1000
    2000
    3000
    
    4000
    
    5000
    6000
    
    7000
    8000
    9000
    
    10000
  )
  
  def test_calories
    elves             = CalorieCounting.get_elves INPUT
    calories          = elves.map &:total_calories
    expected_calories = [6_000, 4_000, 11_000, 24_000, 10_000]
    assert_equal expected_calories, calories
  end
  
  def test_max_calories
    elves        = CalorieCounting.get_elves INPUT
    max          = elves.map(&:total_calories).max
    expected_max = 24_000
    assert_equal expected_max, max
  end
  
  def test_max_three_calories
    elves                  = CalorieCounting.get_elves INPUT
    max_three_sum          = elves.map(&:total_calories).max(3).sum
    expected_max_three_sum = 45_000
    assert_equal expected_max_three_sum, max_three_sum
  end
end
