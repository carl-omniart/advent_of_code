require 'minitest/autorun'

require_relative 'day_03.rb'

class SubmarineTest < Minitest::Test
  DIAGNOSTIC_REPORT = [
    "00100",
    "11110",
    "10110",
    "10111",
    "10101",
    "01111",
    "00111",
    "11100",
    "10000",
    "11001",
    "00010",
    "01010"
  ]
  
  def test_gamma_rate
    # Each bit in the gamma rate can be determined by finding the most common
    # bit in the corresponding position of all numbers in the diagnostic report.
    # Output in decimal.
    
    red_december = Submarine.new "00000", "11111", "01010"
    assert_equal "01010".to_i(2), red_december.gamma_rate
    
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 22, red_december.gamma_rate
  end
  
  def test_epsilon_rate
    # Each bit in the epsilon rate can be determined by finding the least common
    # bit in the corresponding position of all numbers in the diagnostic report.
    # Output in decimal.
    
    red_december = Submarine.new "00000", "11111", "01010"
    assert_equal "10101".to_i(2), red_december.epsilon_rate
    
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 9, red_december.epsilon_rate
  end

  def test_power_consumption
    red_december = Submarine.new "00000", "11111", "01010"
    expectation  = "01010".to_i(2) * "10101".to_i(2)
    assert_equal expectation, red_december.power_consumption
    
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 198, red_december.power_consumption
  end
  
  def test_oxygen_generator_rating
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 23, red_december.oxygen_generator_rating
  end
  
  def test_co2_scrubber_rating
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 10, red_december.co2_scrubber_rating
  end
  
  def test_life_support_rating
    red_december = Submarine.new *DIAGNOSTIC_REPORT
    assert_equal 230, red_december.life_support_rating
  end
end
