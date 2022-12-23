require 'minitest/autorun'
require 'day_05'

class SupplyStacksTest < Minitest::Test
  INPUT = %Q(
        [D]    
    [N] [C]    
    [Z] [M] [P]
     1   2   3
    
    move 1 from 2 to 1
    move 3 from 1 to 3
    move 2 from 2 to 1
    move 1 from 1 to 2
  )
  
  def test_stacks
    dock            = SupplyStacks.parse INPUT
    stacks          = dock.stacks.map &:crates
    expected_stacks = [["N", "Z"], ["D", "C", "M"], ["P"]]
    assert_equal expected_stacks, stacks
  end
  
  def test_top_crates
    dock                = SupplyStacks.parse INPUT
    dock.rearrange_stacks!
    top_crates          = dock.stacks.map(&:top_crate).join
    expected_top_crates = "CMZ"
    assert_equal expected_top_crates, top_crates
  end
  
  def test_top_crates_crate_mover_9001
    dock                = SupplyStacks.parse INPUT, crate_mover_model: 9001
    dock.rearrange_stacks!
    top_crates          = dock.stacks.map(&:top_crate).join
    expected_top_crates = "MCD"
    assert_equal expected_top_crates, top_crates
  end
end
