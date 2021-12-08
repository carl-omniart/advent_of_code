require 'minitest/autorun'

require_relative 'day_01.rb'

class SonarTest < Minitest::Test
  def test_depth_increases
    sonar = Sonar.new 199, 200
    assert_equal 1, sonar.depth_increase_count
    
    sonar = Sonar.new 208, 210, 200, 207, 240
    assert_equal 3, sonar.depth_increase_count
    
    sonar = Sonar.new 199, 200, 208, 210, 200, 207, 240, 269, 260, 263
    assert_equal 7, sonar.depth_increase_count
  end
  
  def test_sliding_window_sums
    sonar = Sonar.new 1, 2, 3, 4, 5
    assert_equal [6, 9, 12], sonar.window_sums
  end
  
  def test_sliding_window_sum_increases
    sonar = Sonar.new 1, 2, 3, 4, 5
    assert_equal 2, sonar.window_sum_increase_count
    
    sonar = Sonar.new 199, 200, 208, 210, 200, 207, 240, 269, 260, 263
    assert_equal 5, sonar.window_sum_increase_count
  end
end
