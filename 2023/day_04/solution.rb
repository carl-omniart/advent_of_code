module Day04
  class << self
    def title
      'Scratchcards'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      Game.parse(input).points
    end
    
    def solve_part_two input
      Game.parse(input).copies
    end
  end
  
  class Game
    class << self
      def parse string
        self.new do |game|
          lines = string.split "\n"
          lines.each { |line| game.add Card.parse(line) }
        end
      end
    end
    
    def initialize
      @cards = {}
      yield self if block_given?
    end
    
    attr_reader :cards
    
    def add card
      cards[card.id] = card
    end
    
    def points
      cards.each_value.map(&:points).sum
    end
    
    def copies
      ids   = cards.keys
      count = ids.map { |id| [id, 1] }.to_h
      
      ids.each do |id|
        cards[id].cards_won.each { |card_won| count[card_won] += count[id] }
      end
      
      count.values.sum
    end
  end
  
  class Card
    class << self
      def parse line
        head, body     = line.split ": "
        id             = head.match(/Card +(\d+)/)[1].to_i
        winners, yours = body.split " | "
        winners        = winners.scan(/\d+/).map &:to_i
        yours          = yours.scan(/\d+/).map &:to_i
      
        self.new id, winners, yours
      end
    end
      
    def initialize id, winners, yours
      @id      = id
      @winners = winners
      @yours   = yours
    end
    
    attr_reader :id
    attr_reader :winners
    attr_reader :yours
    
    def matches
      winners & yours
    end
    
    def points
      return 0 if matches.empty?
      2**(matches.size - 1)
    end
    
    def cards_won
      (id + 1).upto(id + matches.size).to_a
    end
  end
end
