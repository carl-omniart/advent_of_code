require 'minitest/autorun'
require 'day_08'

class HauntedWastelandTest < Minitest::Test
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

  def test_steps_to_zzz_1
    map = HauntedWasteland::Map.parse input(1)
    expected_steps = 2
    assert_equal expected_steps, map.steps_to_zzz
  end
  
  def test_steps_to_zzz_2
    map = HauntedWasteland::Map.parse input(2)
    expected_steps = 6
    assert_equal expected_steps, map.steps_to_zzz
  end
  
  def test_parallel_steps
    map = HauntedWasteland::Map.parse input(3)
    expected_steps = 6
    assert_equal expected_steps, map.ghost_steps_to_z
  end
end
