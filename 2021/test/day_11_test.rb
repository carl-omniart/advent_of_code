require 'minitest/autorun'
require 'day_11'

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
  )
  
  def test_octupi_flashes
    octopi = Octopi.parse INPUT
    
    assert_equal 0, octopi.flash_count
    
    octopi.advance_to 10
    assert_equal 204, octopi.flash_count
    
    octopi.advance_to 100
    assert_equal 1656, octopi.flash_count
  end

  def test_all_flash
    octopi = Octopi.parse INPUT
    
    octopi.advance_to_all_flash
    assert_equal 195, octopi.step
  end
end
