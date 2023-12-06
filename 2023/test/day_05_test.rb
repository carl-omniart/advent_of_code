require 'minitest/autorun'
require 'day_05'

class IfYouGiveASeedAFertilizerTest < Minitest::Test
  INPUT = %Q(
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
  )

  def test_lowest_location_number
    almanac = IfYouGiveASeedAFertilizer::ObjectAlmanac.parse INPUT
    expected_location_number = 35
    assert_equal expected_location_number, almanac.locations.map(&:min).min
  end

  def test_lowest_location_with_more_seeds
    almanac = IfYouGiveASeedAFertilizer::SetAlmanac.parse INPUT
    expected_location_number = 46
    assert_equal expected_location_number, almanac.locations.map(&:min).min
  end
end
