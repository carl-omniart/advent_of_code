require 'minitest/autorun'
require 'day_04'

class CampCleanupTest < Minitest::Test
  INPUT = %Q(
    2-4,6-8
    2-3,4-5
    5-7,7-9
    2-8,3-7
    6-6,4-6
    2-6,4-8
  )
  
  def test_assignment_fully_contained
    assignments    = CampCleanup.parse INPUT
    count          = assignments.count &:fully_contained?
    expected_count = 2
    assert_equal expected_count, count
  end

  def test_assignment_overlaps
    assignments    = CampCleanup.parse INPUT
    count          = assignments.count &:overlap?
    expected_count = 4
    assert_equal expected_count, count
  end
end
