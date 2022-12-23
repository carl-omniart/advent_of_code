require 'minitest/autorun'
require 'day_07'

class NoSpaceLeftOnDeviceTest < Minitest::Test
  INPUT = %Q(
    $ cd /
    $ ls
    dir a
    14848514 b.txt
    8504156 c.dat
    dir d
    $ cd a
    $ ls
    dir e
    29116 f
    2557 g
    62596 h.lst
    $ cd e
    $ ls
    584 i
    $ cd ..
    $ cd ..
    $ cd d
    $ ls
    4060174 j
    8033020 d.log
    5626152 d.ext
    7214296 k
  )
  
  def test_directory_sizes
    disk           = NoSpaceLeftOnDevice.parse INPUT
    sizes          = disk.root.each_dir.map(&:size).sort
    expected_sizes = [584, 94_853, 24_933_642, 48_381_165]
     assert_equal expected_sizes, sizes
  end
  
  def test_directory_size_sum_under_100_000
    disk         = NoSpaceLeftOnDevice.parse INPUT
    sum          = disk.
                     root.
                     each_dir.
                     map(&:size).
                     select { |s| s <= 100_000 }.
                     sum
    expected_sum = 95_437
    assert_equal expected_sum, sum
  end
  
  def test_directory_to_delete
    disk            = NoSpaceLeftOnDevice.parse INPUT
    update_space    =  30_000_000
    space_to_delete = update_space - disk.unused_space
    dir             = disk.
                        root.
                        each_dir.
                        select { |dir| dir.size >= space_to_delete }.
                        min_by(&:size).
                        name
    expected_dir    = "d"
    assert_equal expected_dir, dir
  end
end
