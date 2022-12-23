require 'minitest/autorun'
require 'day_03'

class RucksackReorganizationTest < Minitest::Test
  INPUT = %Q(
    vJrwpWtwJgWrhcsFMMfFFhFp
    jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
    PmmdzqPrVvPwwTWBwg
    wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
    ttgJtRGJQctTZtZT
    CrZsJsPPZsGzwwsLwLmpwMDw
  )
  
  def test_common_item_priority
    rucksacks    = RucksackReorganization.parse INPUT
    sum          = rucksacks.map(&:common_item_priority).sum
    expected_sum = 157
    assert_equal expected_sum, sum
  end
  
  def test_badge_priority
    rucksacks    = RucksackReorganization.parse INPUT
    groups       = RucksackReorganization.group *rucksacks
    sum          = groups.map(&:badge_priority).sum
    expected_sum = 70
    assert_equal expected_sum, sum
  end
end
