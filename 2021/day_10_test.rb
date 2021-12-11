require 'minitest/autorun'

require_relative 'day_10.rb'

class SyntaxTest < Minitest::Test
  INPUT = "
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
  ".strip.split("\n").map &:strip
  
  def test_corrupted_lines
    syntax = Syntax.new *INPUT
    
    assert_equal ["}", ")", "]", ")", ">"], syntax.illegal_closing_brackets
    assert_equal [1197, 3, 57, 3, 25137], syntax.syntax_error_scores
    assert_equal 26397, syntax.total_syntax_error_score    
  end
  
  def test_incomplete_lines
    syntax = Syntax.new *INPUT
    
    expected_characters = [
      "}}]])})]",
      ")}>]})",
      "}}>}>))))",
      "]]}}]}]}>",
      "])}>"
    ]
    
    assert_equal expected_characters, syntax.needed_closers
    
    expected_scores = [
        288_957,
          5_566,
      1_480_781,
        995_444,
            294
    ]
    
    assert_equal expected_scores, syntax.needed_closers_scores
    assert_equal 288_957, syntax.median_needed_closers_score
  end    
end
