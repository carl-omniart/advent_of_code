require 'minitest/autorun'
require 'day_06'

class WaitForItTest < Minitest::Test
  INPUT = %Q(
    Time:      7  15   30
    Distance:  9  40  200
  )

  def test_number_of_ways_to_beat_record
    races = WaitForIt::Race.parse INPUT
    boat  = WaitForIt::Boat.new
    
    expected_product = 288
    ways  = races.map { |race| race.ways_to_beat_record boat }
    assert_equal expected_product, ways.reduce(:*)
  end

  def test_number_of_ways_to_beat_record_in_one_big_race
    race = WaitForIt::OneRace.parse INPUT
    boat = WaitForIt::Boat.new
    
    expected_ways = 71_503
    assert_equal expected_ways, race.ways_to_beat_record(boat)
  end
end
