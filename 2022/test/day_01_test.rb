require 'minitest/autorun'
require 'day_01'

class FoodListTest < Minitest::Test
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
  
  def test_calorie_counts
  	food_list = FoodList.parse INPUT
  	expected_sums = [6000, 4000, 11000, 24000, 10000]
  	assert_equal expected_sums, food_list.calorie_counts
  end
  
  def test_max_calories
  	food_list = FoodList.parse INPUT
  	assert_equal 24000, food_list.max_calories
  end
  
  def test_max_calories_of_top_n_items
  	food_list = FoodList.parse INPUT
  	assert_equal 45000, food_list.max_calories(3)
  end
end
