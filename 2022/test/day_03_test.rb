require 'minitest/autorun'
require 'day_03'

class RucksackTest < Minitest::Test
  INPUT = %Q(
		vJrwpWtwJgWrhcsFMMfFFhFp
		jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
		PmmdzqPrVvPwwTWBwg
		wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
		ttgJtRGJQctTZtZT
		CrZsJsPPZsGzwwsLwLmpwMDw
  )
  
  def test_common_items_priority
  	rucksacks = Rucksack.parse INPUT
  	sum       = rucksacks.map(&:common_items_priority).sum
  	assert_equal 157, sum
  end
  
  def test_badge_priority
  	rucksacks = Rucksack.parse INPUT
  	groups    = rucksacks.each_slice(3).map { |sacks| ElfGroup.new *sacks }
  	sum    		= groups.map(&:badge_priority).sum
  	assert_equal 70, sum
  end
end
