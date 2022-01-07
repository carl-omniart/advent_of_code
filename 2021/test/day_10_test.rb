require 'minitest/autorun'
require 'day_10'

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
  "
  
  def test_corrupted_lines
    syntax = Syntax.parse INPUT
    
    assert_equal ["}", ")", "]", ")", ">"], syntax.illegal_closing_brackets
    assert_equal [1197, 3, 57, 3, 25137], syntax.syntax_error_scores
    assert_equal 26397, syntax.total_syntax_error_score    
  end
  
  def test_incomplete_lines
    syntax = Syntax.parse INPUT
    
    expected_characters = [
      "}}]])})]",
      ")}>]})",
      "}}>}>))))",
      "]]}}]}]}>",
      "])}>"
    ]
    
    assert_equal expected_characters, syntax.needed_closers
    
    expected_scores = [
      288957,
      5566,
      1480781,
      995444,
      294
    ]
    
    assert_equal expected_scores, syntax.needed_closers_scores
    assert_equal 288957, syntax.median_needed_closers_score
  end    
end
