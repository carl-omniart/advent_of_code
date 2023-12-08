module CamelCards
  class Game
    class << self
      def parse string
        lines = clean(string).split "\n"
        hands = lines.map { |line| parse_hand line }
        self.new *hands
      end
      
      def parse_hand line
        Hand.parse line
      end
      
      def clean string
        string.strip.split("\n").map(&:strip).join "\n"
      end
    end
    
    def initialize *hands
      @hands = hands
    end
    
    attr_reader :hands
    
    def winnings
      hands.sort.reverse.each.with_index(1).map { |hand, rank| rank * hand.bid }
    end
  end
  
  class Hand
    include Comparable
    
    @types  = {
      [            5] => :five_of_a_kind,
      [         1, 4] => :four_of_a_kind,
      [         2, 3] => :full_house,
      [      1, 1, 3] => :three_of_a_kind,
      [      1, 2, 2] => :two_pair,
      [   1, 1, 1, 2] => :pair,
      [1, 1, 1, 1, 1] => :high_card
    }
      
    class << self
      attr_reader :types
      
      def inherited child
        child.instance_variable_set :@types, types
      end
            
      def parse line
        labels, bid = line.split " "
        cards       = parse_cards labels
        bid         = bid.to_i
        self.new *cards, bid
      end
      
      def parse_cards labels
        labels.each_char.map { |label| Card.new label.to_sym }
      end
    end
    
    def initialize *cards, bid
      @cards = cards
      @bid   = bid
    end
    
    attr_reader :cards
    attr_reader :bid
    
    def pattern
      cards.map(&:label).tally.values.sort
    end
    
    def type
      self.class.types[pattern]
    end
        
    def rank
      self.class.types.values.index type
    end
    
    def <=> other
      [rank, cards.map(&:rank)] <=> [other.rank, other.cards.map(&:rank)]
    end
  end
  
  class Card
    include Comparable
    
    @labels = %w(A K Q J T 9 8 7 6 5 4 3 2).map &:to_sym
    
    class << self
      attr_reader :labels
      
      def inherited subclass
        subclass.instance_variable_set :@labels, labels
      end
    end
    
    def initialize label
      @label = label
    end
    
    attr_reader :label
    
    def rank
      self.class.labels.index label
    end
    
    def <=> other
      rank <=> other.rank
    end
  end
  
  class GameWithJokers < Game
    class << self
      def parse_hand line
        HandWithJokers.parse line
      end
    end
  end
  
  class HandWithJokers < Hand
    class << self
      def parse_cards labels
        labels.each_char.map { |label| CardWithJokers.new label.to_sym }
      end
    end
    
    def pattern
      tally   = cards.map(&:label).tally
      jokers  = tally.delete(:J) || 0
      tally.values.sort.tap do |ary|
        ary << 0 if ary.empty?
        ary[-1] += jokers
      end
    end
  end
  
  class CardWithJokers < Card
    @labels = %w(A K Q T 9 8 7 6 5 4 3 2 J).map &:to_sym
  end
end
