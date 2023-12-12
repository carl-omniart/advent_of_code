require 'minitest/autorun'
require 'day_08/solution'

class Day08Test < Minitest::Test
  INPUT = {
    1 => %Q(
      RL

      AAA = (BBB, CCC)
      BBB = (DDD, EEE)
      CCC = (ZZZ, GGG)
      DDD = (DDD, DDD)
      EEE = (EEE, EEE)
      GGG = (GGG, GGG)
      ZZZ = (ZZZ, ZZZ)
    ),
    2 => %Q(
      LLR

      AAA = (BBB, BBB)
      BBB = (AAA, ZZZ)
      ZZZ = (ZZZ, ZZZ)
    ),
    3 => %Q(
      LR

      11A = (11B, XXX)
      11B = (XXX, 11Z)
      11Z = (11B, XXX)
      22A = (22B, XXX)
      22B = (22C, 22C)
      22C = (22Z, 22Z)
      22Z = (22B, 22B)
      XXX = (XXX, XXX)
    )
  }

  def input n
    INPUT[n].strip.split("\n").map(&:strip).join "\n"
  end
 
  def test_part_one_a
    assert_equal 2, Day08.solve_part_one(input(1))
  end
  
  def test_part_one_b
    assert_equal 6, Day08.solve_part_one(input(2))
  end
  
  def test_part_two
    assert_equal 6, Day08.solve_part_two(input(3))
  end
end
