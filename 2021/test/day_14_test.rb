require 'minitest/autorun'
require 'day_14'

class PolymerTest < Minitest::Test
  INPUT = %Q(
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
  )
  
  def test_pair_insertions
    polymer = Polymer.parse INPUT
    
    { 1  => 7,
      2  => 13,
      3  => 25,
      4  => 49,
      5  => 97,
      10 => 3073
    }.each do |step, expected_length|
      polymer.advance_to step
      assert_equal expected_length, polymer.length
    end
  end
  
  def test_element_counts
    polymer = Polymer.parse INPUT
    polymer.advance_to 10
    
    { "B" => 1749,
      "C" => 298,
      "H" => 161,
      "N" => 865
    }.each do |element, expected_count|
      assert_equal expected_count, polymer.element_tally[element]
    end
    
    assert_equal "B", polymer.most_common_element
    assert_equal "H", polymer.least_common_element
    
    assert_equal 1588, polymer.count_difference_between_most_and_least_common_elements
  end  
end
