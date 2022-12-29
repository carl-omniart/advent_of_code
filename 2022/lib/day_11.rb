module MonkeyInTheMiddle
  REGEXP = {
    monkey:    /(?=Monkey)/,
    id:        /Monkey (\d+):/,
    items:     /Starting items: ([0-9, ]+)/,
    operation: /Operation: new = ([a-z0-9+* ]+)/,
    divisor:   /Test: divisible by (\d+)/,
    if_true:   /If true: throw to monkey (\d+)/,
    if_false:  /If false: throw to monkey (\d+)/
  }
  
  class << self
    def parse string
      string = stripped_lines(string).join "\n"
      Troop.new { |troop| each_monkey(string) { |monkey| troop.add monkey } }
    end
    
    def stripped_lines string
      string.strip.split("\n").map &:strip
    end
    
    def each_monkey string
      return enum_for(:each_monkey, string) unless block_given?
      string.split(REGEXP[:monkey]).each { |str| yield parse_monkey(str) }
    end
    
    def parse_monkey string      
      Monkey.new do |m|
        m.id        = parse_integer string, :id
        m.operation = parse_operation string
        m.divisor   = parse_integer string, :divisor
        m.if_true   = parse_integer string, :if_true
        m.if_false  = parse_integer string, :if_false
        
        parse_items(string).each { |item| m.catch item }
      end
    end
    
    def parse_items string
      substring = extract_substring string, REGEXP[:items]
      substring.split(", ").map { |worry_level| Item.new worry_level.to_i }
    end
    
    def parse_operation string
      substring      = extract_substring string, REGEXP[:operation]
      a, operator, b = substring.split " "

      lambda do |old|
        aa = (a == "old" ? old : a.to_i)
        bb = (b == "old" ? old : b.to_i)
        aa.send operator, bb
      end
    end
    
    def parse_integer string, field
      substring = extract_substring string, REGEXP[field]
      substring.to_i
    end
    
    def extract_substring string, regex
      string.match(regex)[1]
    end
  end
  
  class Troop
    def initialize
      @monkeys = {}
      @lcm     = 1
      yield self if block_given?
    end
    
    attr_reader :lcm
    
    def each
      return enum_for(:each) unless block_given?
      @monkeys.each_value { |monkey| yield monkey }
    end
    
    def monkeys
      each.to_a
    end
    
    def monkey id
      @monkeys[id]
    end
    
    def add monkey
      monkey.troop        = self
      @monkeys[monkey.id] = monkey
      @lcm                 = lcm.lcm monkey.divisor
      self
    end
    
    def do_rounds n, **options
      1.upto(n) { do_round **options }
    end
    
    def do_round **options
      each { |monkey| monkey.take_turn **options, lcm: lcm }
    end
    
    def monkey_business
      each.map(&:inspected_count).max(2).reduce :*
    end
  end

  class Monkey
    def initialize    
      @items           = []
      @inspected_count = 0
      yield self if block_given?
    end
    
    def items
      @items.dup
    end
    
    attr_accessor :id
    attr_accessor :operation
    attr_accessor :divisor
    attr_accessor :troop
    attr_accessor :relief
    
    attr_reader :inspected_count
    
    attr_writer :if_true
    
    def if_true
      troop.monkey @if_true
    end
    
    attr_writer :if_false

    def if_false
      troop.monkey @if_false
    end
    
    def take_turn relief: true, lcm: nil
      items.each do |item|
        inspect item
        relief ? gets_bored_with(item) : refactor(item, lcm)
        other_monkey = test(item) ? if_true : if_false
        throw_to item, other_monkey
      end
    end
    
    def inspect item
      item.worry_level = operation.call item.worry_level
      @inspected_count += 1
    end
    
    def gets_bored_with item
      item.worry_level /= 3
    end
    
    def refactor item, lcm
      item.worry_level %= lcm
    end
    
    def test item
      (item.worry_level % divisor).zero?
    end

    def catch item
      @items << item
      self
    end
    
    def throw_to item, other_monkey
      @items.delete item
      other_monkey.catch item
      self
    end
  end

  class Item
    def initialize worry_level
      @worry_level = worry_level
    end
    
    attr_accessor :worry_level
  end
end
