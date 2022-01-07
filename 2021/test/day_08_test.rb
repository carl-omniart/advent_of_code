require 'minitest/autorun'
require 'day_08'

class DisplayTest < Minitest::Test
  INPUT = %Q(
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
  )
  
  def test_count_output_values_with_unique_numbers_of_segments
    displays = Display.parse INPUT
    count    = displays.map(&:unique_output_count).sum
    assert_equal 26, count
  end
  
  def test_decoding_patterns
    display = Display.new "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
    
    assert_equal "5353", display.output_value
  
    displays = Display.parse INPUT
    
    expected_output_values = [
      "8394",
      "9781",
      "1197",
      "9361",
      "4873",
      "8418",
      "4548",
      "1625",
      "8717",
      "4315"
    ]
    
    displays.zip(expected_output_values).each do |display, expected|
      assert_equal expected, display.output_value
    end
  end
end
