require 'minitest/autorun'
require 'day_02'

class SubmarineTest < Minitest::Test
  INPUT = %Q(
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
  )
  
  def test_movement
    red_december = Submarine.new
    red_december.set_course INPUT
    
    assert_equal 15, red_december.pos
    assert_equal 10, red_december.depth
  end
end

class AimingSubmarineTest < Minitest::Test
  INPUT = %Q(
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
  )
  
  def test_movement
    red_december = AimingSubmarine.new
    red_december.set_course INPUT

    assert_equal 15, red_december.pos
    assert_equal 60, red_december.depth
  end
end
