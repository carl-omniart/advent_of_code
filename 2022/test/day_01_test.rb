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
  	elves 				    	= CalorieCounting.parse INPUT
  	calories          	= elves.map &:total_calories
  	expected_calories 	= [6000, 4000, 11000, 24000, 10000]
  	assert_equal expected_calories, calories
  end
  
  def test_max_calories
  	elves 							= CalorieCounting.parse INPUT
  	max_calories  			= elves.map(&:total_calories).max
  	expected_max  			= 24_000
  	assert_equal expected_max, max_calories
  end
  
  def test_max_three_calories
  	elves 							= CalorieCounting.parse INPUT
  	max_3_calories_sum	= elves.map(&:total_calories).max(3).sum
  	expected_sum				= 45_000
  	assert_equal expected_sum, max_3_calories_sum
  end
end
