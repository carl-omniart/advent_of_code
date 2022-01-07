require 'minitest/autorun'
require 'day_03'

class DiagnosticTest < Minitest::Test
  INPUT = %Q(
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
  )
  
  def test_gamma_rate
    diagnostic = Diagnostic.parse INPUT
    assert_equal 22, diagnostic.gamma_rate
  end
  
  def test_epsilon_rate
    diagnostic = Diagnostic.parse INPUT
    assert_equal 9, diagnostic.epsilon_rate
  end

  def test_power_consumption
    diagnostic = Diagnostic.parse INPUT
    assert_equal 198, diagnostic.power_consumption
  end
  
  def test_oxygen_generator_rating
    diagnostic = Diagnostic.parse INPUT
    assert_equal 23, diagnostic.oxygen_generator_rating
  end
  
  def test_co2_scrubber_rating
    diagnostic = Diagnostic.parse INPUT
    assert_equal 10, diagnostic.co2_scrubber_rating
  end
  
  def test_life_support_rating
    diagnostic = Diagnostic.parse INPUT
    assert_equal 230, diagnostic.life_support_rating
  end
end
