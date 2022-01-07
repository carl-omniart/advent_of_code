require 'minitest/autorun'
require 'day_07'

class CrabsTest < Minitest::Test
  INPUT = "16,1,2,0,4,2,7,1,2,14"
  
  def test_crab_alignment
    crabs = Crabs.parse INPUT
    
    { 1  => 41,
      2  => 37,
      3  => 39,
      10 => 71
    }.each do |pos, expected_cost|
      assert_equal expected_cost, crabs.fuel_cost(pos)
    end
    
    assert_equal 2, crabs.lowest_fuel_position
  end
end

class NewCrabsTest < Minitest::Test
  INPUT = "16,1,2,0,4,2,7,1,2,14"
  
  def test_crab_alignment
    crabs = NewCrabs.parse INPUT
        
    assert_equal 206, crabs.fuel_cost(2)
    assert_equal   5, crabs.lowest_fuel_position
    assert_equal 168, crabs.lowest_fuel_cost
  end
end
