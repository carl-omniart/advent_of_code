require 'minitest/autorun'
require 'day_07'

class CamelCardsTest < Minitest::Test
  INPUT = %Q(
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
  )

  def test_total_winnings
    game = CamelCards::Game.parse INPUT
    expected_winnings = 6440
    assert_equal expected_winnings, game.winnings.sum
  end
  
  def test_total_winnings_with_jokers
    game = CamelCards::GameWithJokers.parse INPUT
    expected_winnings = 5905
    p game.hands.sort.map { |hand| hand.bid }
    assert_equal expected_winnings, game.winnings.sum
  end
end
