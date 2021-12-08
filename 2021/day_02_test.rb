require 'minitest/autorun'

require_relative 'day_02.rb'

class SubmarineTest < Minitest::Test
  def test_initial_position_and_depth
    red_december = Submarine.new
    
    assert_equal 0, red_december.position
    assert_equal 0, red_december.depth
  end
  
  def test_movement
    red_december = Submarine.new
    
    red_december.forward 4
    assert_equal 4, red_december.position
    assert_equal 0, red_december.depth
    
    red_december.down 8
    assert_equal 4, red_december.position
    assert_equal 8, red_december.depth
    
    red_december.forward 3
    assert_equal 7, red_december.position
    assert_equal 8, red_december.depth
    
    red_december.up 6
    assert_equal 7, red_december.position
    assert_equal 2, red_december.depth
  end
  
  def test_set_course
    course = [
      "forward 5",
      "down 5",
      "forward 8",
      "up 3",
      "down 8",
      "forward 2"
    ]

    red_december = Submarine.new
    red_december.set_course *course
    
    assert_equal 15, red_december.position
    assert_equal 10, red_december.depth
  end
end

class AimingSubmarineTest < Minitest::Test
  def test_initial_aim
    red_december = AimingSubmarine.new
    
    assert_equal 0, red_december.aim
  end
  
  def test_movement
    red_december = AimingSubmarine.new
    
    red_december.forward 4
    assert_equal 4, red_december.position
    assert_equal 0, red_december.depth
    assert_equal 0, red_december.aim
    
    red_december.down 8
    assert_equal 4, red_december.position
    assert_equal 0, red_december.depth
    assert_equal 8, red_december.aim
    
    red_december.forward 3
    assert_equal 7, red_december.position
    assert_equal 24, red_december.depth
    assert_equal 8, red_december.aim
    
    red_december.up 6
    assert_equal 7, red_december.position
    assert_equal 24, red_december.depth
    assert_equal 2, red_december.aim
    
    red_december.forward 5
    assert_equal 12, red_december.position
    assert_equal 34, red_december.depth
    assert_equal 2, red_december.aim
    
    red_december.up 7
    assert_equal 12, red_december.position
    assert_equal 34, red_december.depth
    assert_equal -5, red_december.aim
    
    red_december.forward 6
    assert_equal 18, red_december.position
    assert_equal 4, red_december.depth
    assert_equal -5, red_december.aim
  end
  
  def test_set_course
    course = [
      "forward 5",
      "down 5",
      "forward 8",
      "up 8",
      "forward 2"
    ]

    red_december = AimingSubmarine.new
    red_december.set_course *course
    
    assert_equal 15, red_december.position
    assert_equal 34, red_december.depth
  end
end
