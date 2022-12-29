require 'minitest/autorun'
require 'day_11'

class MonkeyInTheMiddleTest < Minitest::Test
  INPUT = %Q(
    Monkey 0:
      Starting items: 79, 98
      Operation: new = old * 19
      Test: divisible by 23
        If true: throw to monkey 2
        If false: throw to monkey 3

    Monkey 1:
      Starting items: 54, 65, 75, 74
      Operation: new = old + 6
      Test: divisible by 19
        If true: throw to monkey 2
        If false: throw to monkey 0

    Monkey 2:
      Starting items: 79, 60, 97
      Operation: new = old * old
      Test: divisible by 13
        If true: throw to monkey 1
        If false: throw to monkey 3

    Monkey 3:
      Starting items: 74
      Operation: new = old + 3
      Test: divisible by 17
        If true: throw to monkey 0
        If false: throw to monkey 1
  )
  
  def test_item_tossing
    troop           = MonkeyInTheMiddle.parse INPUT
    troop.do_round
    items           = troop.monkeys.map { |m| m.items.map(&:worry_level) }
    expected_items  = [ [20, 23, 27, 26],
                        [2080, 25, 167, 207, 401, 1046],
                        [],
                        []
                      ]
    assert_equal expected_items, items
  end
  
  def test_monkey_business
    troop = MonkeyInTheMiddle.parse INPUT
    troop.do_rounds 20
    assert_equal 10_605, troop.monkey_business
  end

  def test_monkey_business_without_relief
    troop = MonkeyInTheMiddle.parse INPUT
    troop.do_rounds 10_000, relief: false
    assert_equal 2_713_310_158, troop.monkey_business
  end
end
