require 'minitest/autorun'
require 'day_09'

class HeightMapTest < Minitest::Test
  INPUT = %Q(
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
  )
  
  def test_find_low_points
    map = HeightMap.parse INPUT
    
    expected_low_points = [
      [1, 0],
      [9, 0],
      [2, 2],
      [6, 4]
    ]
    
    assert_empty expected_low_points - map.low_points
  end
  
  def test_find_risk_level
    map = HeightMap.parse INPUT
    
    assert_equal [2, 1, 6, 6].sort, map.risk_levels.sort
    assert_equal 15, map.risk_level_sum
  end
  
  def test_basins
    map = HeightMap.parse INPUT
    
    assert_equal [3, 9, 14, 9].sort, map.basin_sizes.sort
    assert_equal 1134, map.product_of_three_largest_basin_sizes
  end
end
