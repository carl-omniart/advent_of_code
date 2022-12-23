require 'minitest/autorun'
require 'day_06'

class TuningTroubleTest < Minitest::Test
  INPUT = %w(
    mjqjpqmgbljsphdztnvjfqwrcgsmlb
    bvwbjplbgvbhsrlpgdmjqwftvncz
    nppdvjthqldpwncqszvftbrmjlhg
    nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
    zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
  )
  
  def test_start_of_packet_marker_position
    device    = TuningTrouble::HandheldDevice.new
    positions = INPUT.map do |signal|
                  device.lock_on_to(signal).start_of_packet_marker_position
                end
    expected_positions = [7, 5, 6, 10, 11]
    assert_equal expected_positions, positions
  end

  def test_start_of_message_marker_position
    device    = TuningTrouble::HandheldDevice.new
    positions = INPUT.map do |signal|
                  device.lock_on_to(signal).start_of_message_marker_position
                end
    expected_positions = [19, 23, 23, 29, 26]
    assert_equal expected_positions, positions
  end
end
