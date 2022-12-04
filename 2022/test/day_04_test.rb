require 'minitest/autorun'
require 'day_04'

class RucksackTest < Minitest::Test
  INPUT = %Q(
		2-4,6-8
		2-3,4-5
		5-7,7-9
		2-8,3-7
		6-6,4-6
		2-6,4-8
  )
  
  def test_assignment_fully_contained
  	assignments = SectionAssignments.parse INPUT
  	assert_equal 2, assignments.count(&:fully_contained?)
  end

  def test_assignment_overlaps
  	assignments = SectionAssignments.parse INPUT
  	assert_equal 4, assignments.count(&:overlap?)
  end
end
