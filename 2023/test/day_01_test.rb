require 'minitest/autorun'
require 'day_01'

class TrebuchetTest < Minitest::Test
  INPUT_1 = %Q(
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
  )
  
  INPUT_2 = %Q(
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    1oneight
  )
  
  # NOTE: Added last line to INPUT_2 to test that both "one" and "eight" scan
  
  def test_calibration_values
    document     = Trebuchet::Document.parse INPUT_1
    expected_sum = 142
    assert_equal expected_sum, document.sum
  end
  
  def test_calibration_values_with_words
    document       = Trebuchet::Document.parse INPUT_2
    document.words = true
    expected_sum   = 281 + 18 # 18 is for "1oneeight"
    assert_equal expected_sum, document.sum
  end
end
