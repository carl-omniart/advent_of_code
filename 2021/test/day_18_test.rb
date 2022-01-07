require 'minitest/autorun'
require "day_18"

class SnailfishTest < Minitest::Test
  INPUT = %Q(
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
  )

  def test_addition
    input = %Q(
      [1,1]
      [2,2]
      [3,3]
      [4,4]
      [5,5]
      [6,6]
    )
    
    snailfish = Snailfish.parse input
    sum       = snailfish[0..3].inject :+
    
    assert_equal "[[[[1,1],[2,2]],[3,3]],[4,4]]", sum.to_s
    
    sum += snailfish[4]
    assert_equal "[[[[3,0],[5,3]],[4,4]],[5,5]]", sum.to_s
    
    sum += snailfish[5]
    assert_equal "[[[[5,0],[7,4]],[5,5]],[6,6]]", sum.to_s
    
    input = %Q(
      [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
      [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
      [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
      [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
      [7,[5,[[3,8],[1,4]]]]
      [[2,[2,2]],[8,[8,1]]]
      [2,9]
      [1,[[[9,3],9],[[9,0],[0,7]]]]
      [[[5,[7,4]],7],1]
      [[[[4,2],2],6],[8,7]]
    )
    
    snailfish = Snailfish.parse input
    sum       = snailfish.inject :+
    
    expected  = "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"
    assert_equal expected, sum.to_s
  end
  
  def test_magnitude
    { "[[1,2],[[3,4],5]]"                                     =>  143,
      "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"                     => 1384,
      "[[[[1,1],[2,2]],[3,3]],[4,4]]"                         =>  445,
      "[[[[3,0],[5,3]],[4,4]],[5,5]]"                         =>  791,
      "[[[[5,0],[7,4]],[5,5]],[6,6]]"                         => 1137,
      "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]" => 3488
    }.each do |input, magnitude|
      snailfish = Snailfish.parse(input).first
      assert_equal magnitude, snailfish.magnitude
    end
  end
  
  def test_sum_and_magnitude
    snailfish = Snailfish.parse INPUT
    sum       = snailfish.inject :+
    
    expected  = "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"
    assert_equal expected, sum.to_s
    assert_equal 4140, sum.magnitude
  end
  
  def test_find_largest_magnitude
    magnitudes = INPUT.strip.split("\n").permutation(2).map do |lines|
      Snailfish.parse(lines.join("\n")).inject(:+).magnitude
    end
    
    assert_equal 3993, magnitudes.max
  end
end
