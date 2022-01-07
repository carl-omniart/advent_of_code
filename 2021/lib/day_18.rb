class Snailfish
  def self.parse input
    input.strip.split("\n").map do |line|
      ary = str_to_ary line.strip
      self.new ary
    end
  end
  
  def self.str_to_ary str
    str, arys = disassemble_string str
    assemble_array str, arys
  end
  
  def self.disassemble_string str, arys = []
    offset = arys.size 
    str.scan(/\[[\da]+,[\da]+\]/).each_with_index do |str_ary, i|
      str.sub! str_ary, "a#{i + offset}"
      arys << str_ary.scan(/[\da]+/)
    end
    str =~ /^a\d+$/ ? [str, arys] : disassemble_string(str, arys)
  end
  
  def self.assemble_array str, arys
    if str.start_with?("a")
      i = str.scan(/\d+/).first.to_i
      arys[i].map { |sub_str| assemble_array sub_str, arys }
    else
      str.to_i
    end
  end
  
  def initialize ary
    @outer_pair = Pair.new ary
  end
  
  attr_reader :outer_pair
  
  def to_s
    outer_pair.to_s
  end
  
  alias_method :inspect, :to_s
  
  def == other
    outer_pair == other.outer_pair
  end
  
  def + other
    Snailfish.new([outer_pair, other.outer_pair]).reduce!
  end
  
  def magnitude
    outer_pair.magnitude
  end
  
  def reduce!
    while element = too_deep_pair || too_large_number
      element.reduce!
    end
    self
  end
  
  def each_element
    return enum_for(:each_element) unless block_given?
    outer_pair.each_element { |element| yield element }
  end
  
  def too_deep_pair
    each_element.select(&:pair?).find &:too_deep?
  end
  
  def too_large_number
    each_element.select(&:number?).find &:too_large?
  end
end

class Element
  def initialize parent
    @parent = parent
  end
  
  def each_element
    return enum_for(:each_element) unless block_given?
    yield self
  end
  
  attr_accessor :parent
end

class Pair < Element
  def initialize ary, parent = nil
    super parent
    
    @left, @right = ary.map do |element|
      case element
      when Integer
        RegularNumber.new element, self
      when Array
        Pair.new element, self
      when Pair
        element.parent = self
        element
      end
    end
  end
  
  def to_s
    "[#{left},#{right}]"
  end
  
  alias_method :inspect, :to_s
  
  attr_reader :left
  attr_reader :right
    
  def elements
    [left, right]
  end
  
  def replace_with old, new
    @left = new if left.equal? old
    @right = new if right.equal? old
    new
  end
  
  def number?
    false
  end

  def pair?
    true
  end
  
  def inner?
    left.number? && right.number?
  end
  
  def too_deep?
    inner? && depth > 4
  end

  def depth
    parent ? parent.depth + 1 : 1
  end
  
  def magnitude
    3 * left.magnitude + 2 * right.magnitude
  end
  
  def == other
    return false unless other.is_a? Pair
    elements == other.elements
  end
  
  def reduce!
    too_deep? ? explode! : self
  end
  
  def explode!
    parent.add :left, self, left
    parent.add :right, self, right
    parent.replace_with self, RegularNumber.new(0, parent)
  end
  
  def add direction, sender, number
    receiver = case sender
    when left
      direction == :left ? parent :  right      
    when right
      direction == :left ?   left : parent
    when parent
      direction == :left ?  right :   left
    end
    
    receiver.add(direction, self, number) if receiver
  end
  
  def each_element
    super
    elements.each do |side|
      side.each_element { |element| yield element }
    end
  end
end

class RegularNumber < Element
  def initialize value, parent
    super parent
    @value  = value
  end
  
  def to_s
    value.to_s
  end
  
  alias_method :inspect, :to_s
  
  attr_reader :value

  alias_method :to_i, :value
  alias_method :magnitude, :value
  
  def depth
    parent.depth + 1
  end
  
  def number?
    true
  end
  
  def pair?
    false
  end
  
  def too_large?
    value >= 10
  end
  
  def + other
    number = RegularNumber.new value + other.value, parent
    parent.replace_with self, number
  end
  
  def == other
    return false unless other.is_a? RegularNumber
    value == other.value
  end
  
  def add direction, sender, number
    self.+ number
  end
  
  def reduce!
    too_large? ? split! : self
  end
  
  def split!
    parent.replace_with self, split_pair
  end
  
  def split_pair
    Pair.new [value / 2, (value + 1) / 2], parent
  end
end
