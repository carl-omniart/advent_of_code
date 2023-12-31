require 'minitest/autorun'
require 'day_15/solution'

class Day15Test < Minitest::Test
  INPUT = {
    1 => %Q(HASH),
    2 => %Q(rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7)
  }
  
  def input n
    INPUT[n].strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one_a
    assert_equal 52, Day15.solve_part_one(input 1)
  end
  
  def test_part_one_b
    assert_equal 1320, Day15.solve_part_one(input 2)
  end
  
  def test_part_two
    assert_equal 145, Day15.solve_part_two(input 2)
  end
end
