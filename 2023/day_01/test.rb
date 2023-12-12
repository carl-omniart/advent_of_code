require 'minitest/autorun'
require 'day_01/solution'

class Day01Test < Minitest::Test
  INPUT = {
    1 => %Q(
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    ),
    2 => %Q(
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
      1oneight
    )
  }
  
  # NOTE: Added last line to INPUT[2] to test that both "one" and "eight" scan
  
  def input n
    INPUT[n].strip.split("\n").map(&:strip).join("\n")
  end
  
  def test_part_one
    assert_equal 142, Day01.solve_part_one(input(1))
  end
  
  def test_part_two
    assert_equal 299, Day01.solve_part_two(input(2))
  end
end
