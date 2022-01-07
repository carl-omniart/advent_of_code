require 'minitest/autorun'
require 'day_12'

class CaveSystemTest < Minitest::Test
  INPUT = {
    1 => %Q(
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
    ),
    2 => %Q(
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
    ),
    3 => %Q(
      fs-end
      he-DX
      fs-he
      start-DX
      pj-DX
      end-zg
      zg-sl
      zg-pj
      pj-he
      RW-he
      fs-DX
      pj-RW
      zg-RW
      start-pj
      he-WI
      zg-he
      pj-fs
      start-RW
    )
  }
  
  def test_paths_that_may_not_visit_a_small_cave_twice
    { 1 => 10,
      2 => 19,
      3 => 226
    }.each do |i, count|
      cave_system = CaveSystem.parse INPUT[i]
      assert_equal count, cave_system.paths_that_visit_no_small_cave_twice.size      
    end
  end
  
  def test_paths_that_may_visit_one_small_cave_twice
    { 1 => 36,
      2 => 103,
      3 => 3509
    }.each do |i, count|
      cave_system = CaveSystem.parse INPUT[i]
      assert_equal count, cave_system.paths_that_visit_one_small_cave_twice.size
    end
  end
end
