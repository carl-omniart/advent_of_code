require 'minitest/autorun'

require_relative 'day_06.rb'

class LanternfishSchoolTest < Minitest::Test
  def test_spawning_model
    fish = Lanternfish.new 3
    
    fish.age 3
    assert_equal 1, fish.count
    
    fish.age 1
    assert_equal 2, fish.count
        
    fish = Lanternfish.new 3, 4, 3, 1, 2
    
    [ [2,3,2,0,1],
      [1,2,1,6,0,8],
      [0,1,0,5,6,7,8],
      [6,0,6,4,5,6,7,8,8],
      [5,6,5,3,4,5,6,7,7,8],
      [4,5,4,2,3,4,5,6,6,7],
      [3,4,3,1,2,3,4,5,5,6],
      [2,3,2,0,1,2,3,4,4,5],
      [1,2,1,6,0,1,2,3,3,4,8],
      [0,1,0,5,6,0,1,2,2,3,7,8],
      [6,0,6,4,5,6,0,1,1,2,6,7,8,8,8],
      [5,6,5,3,4,5,6,0,0,1,5,6,7,7,7,8,8],
      [4,5,4,2,3,4,5,6,6,0,4,5,6,6,6,7,7,8,8],
      [3,4,3,1,2,3,4,5,5,6,3,4,5,5,5,6,6,7,7,8],
      [2,3,2,0,1,2,3,4,4,5,2,3,4,4,4,5,5,6,6,7],
      [1,2,1,6,0,1,2,3,3,4,1,2,3,3,3,4,4,5,5,6,8],
      [0,1,0,5,6,0,1,2,2,3,0,1,2,2,2,3,3,4,4,5,7,8],
      [6,0,6,4,5,6,0,1,1,2,6,0,1,1,1,2,2,3,3,4,6,7,8,8,8,8]
    ].map(&:size).each do |expected_count|
      fish.age
      assert_equal expected_count, fish.count
    end
    
    fish.age_until 80
    assert_equal 5934, fish.count
  end
end