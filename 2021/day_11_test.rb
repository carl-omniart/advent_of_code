require 'minitest/autorun'

require_relative 'day_11.rb'

class OctopiTest < Minitest::Test
  INPUT = %Q(
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
  ).strip.split("\n").map &:strip
  
  def test_octupus_flashes
    octopi = Octopi.new *INPUT
    
    assert_equal 0, octopi.flash_count
    
    octopi.advance_to 10
    assert_equal 204, octopi.flash_count
    
    octopi.advance_to 100
    assert_equal 1656, octopi.flash_count
  end

  def test_all_flash
    octopi = Octopi.new *INPUT
    
    octopi.advance_to_all_flash
    assert_equal 195, octopi.step
  end
end
