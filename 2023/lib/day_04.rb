module Scratchcards
  class Game
    def self.parse string
      self.new do |game|
        lines = string.strip.split("\n").map &:strip
        lines.each { |line| game.add Card.parse(line) }
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
        multiplier = count[id]
        cards[id].won_ids.each { |won_id| count[won_id] += multiplier }
      end
      
      count.values.sum
    end
  end
  
  class Card
    def self.parse line
      head, body     = line.split ": "
      id             = head.match(/Card +(\d+)/)[1].to_i
      winners, yours = body.split " | "
      winners        = winners.scan(/\d+/).map &:to_i
      yours          = yours.scan(/\d+/).map &:to_i
      
      self.new id, winners, yours
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
    
    def won_ids
      (id + 1).upto(id + matches.size).to_a
    end
  end
end