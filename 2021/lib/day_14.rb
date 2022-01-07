class Polymer
  def self.parse input
    input     = input.strip.split("\n").map &:strip
    template  = input.shift
    input.shift
    rules     = Hash[input.map { |line| line.split " -> " }]
    
    self.new template, rules    
  end
  
  def initialize template, rules
    @pairs = tally_hash
    template.chars.each_cons(2).map(&:join).each { |pair| @pairs[pair] += 1 }
    @end_elements = [template[0], template[-1]]
    
    @rules = {}
    rules.each do |old_pair, insertion|
      new_pair_1 = old_pair[0] + insertion
      new_pair_2 = insertion + old_pair[1]
    
      @rules[old_pair] = tally_hash
      @rules[old_pair][old_pair]   -= 1
      @rules[old_pair][new_pair_1] += 1
      @rules[old_pair][new_pair_2] += 1
    end
    
    @steps = 0
  end
  
  attr_reader :steps
  attr_reader :end_elements
  
  def each_pair
    return enum_for(:each_pair) unless block_given?
    @pairs.each { |pair, count| yield pair, count }
  end
  
  def advance_one
    new_pairs = @pairs.dup
    
    each_pair do |pair, count|
      @rules[pair].each { |new_pair, adj| new_pairs[new_pair] += count * adj }
    end
    
    @pairs = new_pairs
    
    @steps += 1
    self
  end
  
  def advance_to step
    advance_one until @steps >= step
  end
  
  def length
    @pairs.values.sum + 1
  end
  
  def elements
    @pairs.keys.flat_map(&:chars).uniq
  end
  
  def element_tally
    tally = tally_hash
    each_pair { |pair, count| pair.each_char { |elem| tally[elem] += count } }
    end_elements.each { |elem| tally[elem] += 1 }
    tally.transform_values { |double_count| double_count / 2 }
  end
  
  def most_common_element
    tally = element_tally
    elements.max_by { |element| tally[element] }
  end
  
  def least_common_element
    tally = element_tally
    elements.min_by { |element| tally[element] }
  end
  
  def count_difference_between_most_and_least_common_elements
    tally = element_tally
    tally[most_common_element] - tally[least_common_element]
  end
  
  private
  
  def tally_hash
    Hash.new { |hash, key| hash[key] = 0 }
  end
end
