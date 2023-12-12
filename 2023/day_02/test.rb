require 'minitest/autorun'
require 'day_02/solution'

class Day02Test < Minitest::Test
  INPUT = %Q(
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 8, Day02.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 2286, Day02.solve_part_two(input)
  end
end
