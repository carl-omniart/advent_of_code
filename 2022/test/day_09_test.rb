require 'minitest/autorun'
require 'day_09'

class RopeBridgeTest < Minitest::Test
  INPUT = %Q(
    R 4
    U 4
    L 3
    D 1
    R 4
    D 1
    L 5
    R 2
  )
  
  INPUT_2 = %Q(
    R 5
    U 8
    L 8
    D 3
    R 17
    D 10
    L 25
    U 20
  )
  
  def test_positions_visited_by_tail_in_2_knot_rope
    steps          = RopeBridge.parse INPUT
    rope           = RopeBridge::Rope.new 2
    steps.each { |dir, n| rope.move dir, n }
    count          = rope.log(2).uniq.size
    expected_count = 13
    assert_equal expected_count, count
  end
  
  def test_positions_visited_by_tail_in_10_knot_rope
    steps          = RopeBridge.parse INPUT_2
    rope           = RopeBridge::Rope.new 10
    steps.each { |dir, n| rope.move dir, n }
    count          = rope.log(10).uniq.size
    expected_count = 36
    assert_equal expected_count, count
  end
end
