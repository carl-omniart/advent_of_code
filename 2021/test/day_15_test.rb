require 'minitest/autorun'
require 'day_15'

class CavernTest < Minitest::Test
  INPUT = %Q(
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
  )
  
  def test_path_with_lowest_total_risk
    cavern = Cavern.parse INPUT
    
    cavern.calculate_total_risk
    lowest_risk = cavern.lowest_total_risk
    
    assert_equal 40, lowest_risk
  end
  
  def test_big_cavern_path_with_lowest_total_risk
    big_cavern = BigCavern.parse INPUT
    
    big_cavern.calculate_total_risk
    lowest_risk = big_cavern.lowest_total_risk
    
    assert_equal 315, lowest_risk
  end
end
