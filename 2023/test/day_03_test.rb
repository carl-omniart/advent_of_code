require 'minitest/autorun'
require 'day_03'

class GearRatiosTest < Minitest::Test
  INPUT = %Q(
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
  )

  def test_part_numbers_sum
    schematic = GearRatios::Schematic.parse INPUT
    expected_sum = 4361
    assert_equal expected_sum, schematic.part_numbers.map(&:value).sum
  end
  
  def test_gear_ratios_sum
    schematic = GearRatios::Schematic.parse INPUT
    expected_sum = 467_835
    assert_equal expected_sum, schematic.gears.map(&:gear_ratio).sum
  end
end
