require 'minitest/autorun'
require 'day_08'

class TreetopTreeHouseTest < Minitest::Test
  INPUT = %Q(
    30373
    25512
    65332
    33549
    35390
  )
  
  def test_tree_visibility
    forest         = TreetopTreeHouse.parse INPUT
    count          = forest.visible_tree_count
    expected_count = 21
    assert_equal expected_count, count
  end
  
  def test_max_scenic_scores
    forest         = TreetopTreeHouse.parse INPUT
    score          = forest.scenic_scores.max
    expected_score = 8
    assert_equal expected_score, score
  end
end
