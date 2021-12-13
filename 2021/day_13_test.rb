require 'minitest/autorun'

require_relative 'day_13.rb'

class TransparentOrigamiTest < Minitest::Test
  INPUT = %Q(
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
  )
  
  def test_transparent_paper
    expected_grid = [
      "...#..#..#.",
      "....#......",
      "...........",
      "#..........",
      "...#....#.#",
      "...........",
      "...........",
      "...........",
      "...........",
      "...........",
      ".#....#.##.",
      "....#......",
      "......#...#",
      "#..........",
      "#.#........"
    ]
    
    paper = TransparentPaper.new INPUT
    assert_equal expected_grid, paper.visible_dots
    assert_equal 18, paper.visible_dot_count
    
    paper.fold
    assert_equal 17, paper.visible_dot_count
    
    expected_grid = [
      "#####",
      "#...#",
      "#...#",
      "#...#",
      "#####"
    ]
    
    paper.fold_all
    assert_equal expected_grid, paper.visible_dots
  end
end
