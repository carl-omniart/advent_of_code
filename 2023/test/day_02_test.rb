require 'minitest/autorun'
require 'day_02'

class CubeConundrumTest < Minitest::Test
  INPUT = %Q(
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  )

  def test_possible_games
    games          = CubeConundrum.parse_games INPUT
    bag            = CubeConundrum::Bag.new red: 13, green: 13, blue: 14
    possible_games = games.select { |game| bag.possible_game? game }
    expected_sum   = 8
    assert_equal expected_sum, possible_games.map(&:id).sum
  end
  
  def test_fewest_cubes
    games = CubeConundrum.parse_games INPUT
    bags  = games.map { |game| CubeConundrum::Bag.new **game.maxes }
    expected_sum = 2286
    assert_equal expected_sum, bags.map(&:power).sum
  end
end
