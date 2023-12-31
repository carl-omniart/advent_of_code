require 'minitest/autorun'
require 'day_16/solution'

class Day16Test < Minitest::Test
  INPUT = %q(
    .|...\....
    |.-.\.....
    .....|-...
    ........|.
    ..........
    .........\
    ..../.\\\\..
    .-.-/..|..
    .|....-|.\
    ..//.|....
  )
  
  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_part_one
    assert_equal 46, Day16.solve_part_one(input)
  end
  
  def test_part_two
    assert_equal 51, Day16.solve_part_two(input)
  end
end
