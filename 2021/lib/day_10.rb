class Bracket
  @instances = []
  
  class << self
    attr_reader :instances
    
    def << instance
      instances << instance
    end
    
    def lefts
      instances.map &:left
    end
    
    def rights
      instances.map &:right
    end
    
    def pairs
      instances.map &:pair
    end
    
    def by_left bracket
      @l_index ||= Hash[instances.map { |b| [b.left, b] }]
      @l_index[bracket]
    end
    
    def by_right bracket
      @r_index ||= Hash[instances.map { |b| [b.right, b] }]
      @r_index[bracket]
    end
    
    def lefts_pattern
      Regexp.new "[#{escaped(lefts).join}]"
    end
    
    def rights_pattern
      Regexp.new "[#{escaped(rights).join}]"
    end
    
    def pairs_pattern
      Regexp.new "(#{escaped(pairs).join("|")})"
    end
    
    def unmatched_pairs_pattern
      Regexp.new "[#{escaped(lefts).join}][#{escaped(rights).join}]"
    end
    
    private
    
    def escaped string_array
      string_array.map { |string| Regexp.escape string }
    end
  end
      
  def initialize left, right, illegal_score, completion_score
    @left   = left
    @right  = right
    @illegal_score    = illegal_score
    @completion_score = completion_score
    
    self.class << self
  end
  
  attr_reader  :left
  alias_method :opener, :left

  attr_reader  :right
  alias_method :closer, :right
  
  def pair
    left + right
  end

  attr_reader :illegal_score
  attr_reader :completion_score  
end

class Syntax
  def self.parse input
    lines = input.strip.split("\n").map &:strip
    self.new *lines
  end
    
  def initialize *lines
    @lines = lines
  end
  
  attr_reader :lines
  
  def reduced line
    pairs = Bracket.pairs_pattern
    line.dup.tap { |l| l.gsub!(pairs, "") while l =~ pairs }
  end
  
  def complete_lines
    lines.select { |line| reduced(line).empty? }
  end
  
  def corrupt_lines
    unmatched_pair = Bracket.unmatched_pairs_pattern
    lines.select { |line| reduced(line) =~ unmatched_pair }
  end
  
  def incomplete_lines
    unmatched_pair = Bracket.unmatched_pairs_pattern
    lines.reject { |line| reduced(line) =~ unmatched_pair }
  end
  
  def illegal_closing_brackets
    unmatched_pair = Bracket.unmatched_pairs_pattern
    corrupt_lines.map do |line|
      line = reduced line
      i = line.index unmatched_pair
      line[i + 1]
    end
  end
  
  def syntax_error_scores
    illegal_closing_brackets.map { |char| Bracket.by_right(char).illegal_score }
  end
  
  def total_syntax_error_score
    syntax_error_scores.sum
  end
  
  def needed_closers
    incomplete_lines.map do |line|
      reduced(line).reverse.each_char.map { |b| Bracket.by_left(b).right }.join
    end
  end
  
  def needed_closers_scores
    needed_closers.map do |brackets|
      brackets.each_char.inject(0) do |sum, bracket|
        sum * 5 + Bracket.by_right(bracket).completion_score
      end
    end
  end
  
  def median_needed_closers_score
    scores = needed_closers_scores.sort
    scores[scores.size / 2]
  end
end

[ ["(", ")",     3, 1],
  ["[", "]",    57, 2],
  ["{", "}",  1197, 3],
  ["<", ">", 25137, 4]
].each { |setup| Bracket.new *setup }
    
