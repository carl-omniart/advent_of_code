require 'minitest/autorun'
require 'day_01'

class SonarTest < Minitest::Test
  INPUT = %Q(
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
  )
  
  def test_depths_increase_count
    sonar = Sonar.parse INPUT
    assert_equal 7, sonar.depths_increase_count
  end
  
  def test_sliding_window_sums
    sonar = Sonar.parse INPUT
    expected_sums = [607, 618, 618, 617, 647, 716, 769, 792]
    assert_equal expected_sums, sonar.sliding_window_sums(3)
  end
  
  def test_sliding_window_sums_increase_count
    sonar = Sonar.parse INPUT
    assert_equal 5, sonar.sliding_window_sums_increase_count(3)
  end
end
