require 'minitest/autorun'
require 'day_09'

class MirageMaintenanceTest < Minitest::Test
  INPUT = %Q(
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
  )

  def input
    INPUT.strip.split("\n").map(&:strip).join "\n"
  end
  
  def test_predict_next_value
    oasis = MirageMaintenance::OASIS.parse input
    expected_sum = 114
    assert_equal expected_sum, oasis.histories.map(&:predicted_next_value).sum
  end

  def test_predict_previous_value
    oasis = MirageMaintenance::OASIS.parse input
    expected_sum = 2
    assert_equal expected_sum, oasis.histories.map(&:predicted_prev_value).sum
  end
end
