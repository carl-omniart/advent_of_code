require 'minitest/autorun'
require 'day_12/solution'

class Day12Test < Minitest::Test
  INPUT = %Q(
    ???.### 1,1,3
    .??..??...?##. 1,1,3
    ?#?#?#?#?#?#?#? 1,3,1,6
    ????.#...#... 4,1,1
    ????.######..#####. 1,6,5
    ?###???????? 3,2,1
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 21, Day12.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 525_152, Day12.solve_part_two(input)
  end
end
