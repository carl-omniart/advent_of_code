class Display
  def self.parse input
    entries = input.strip.split("\n").map &:strip
    entries.map { |entry| self.new entry }
  end
  
  def initialize entry
    @patterns, @output = entry.split("|").map { |string| string.split " " }

    @patterns.map! { |pattern| pattern.chars.map.sort.map &:to_sym }
    @output.map!   { |pattern| pattern.chars.map.sort.map &:to_sym }
    
    @code = {}
    decode_patterns
  end
  
  attr_reader :patterns
  attr_reader :output
  attr_reader :code
  
  def unique_output_count
    @output.count { |value| [2, 3, 4, 7].include? value.length }
  end
  
  def decode_patterns
    code["1"] = patterns.find { |pat| pat.size == 2 }
    code["7"] = patterns.find { |pat| pat.size == 3 }
    code["4"] = patterns.find { |pat| pat.size == 4 }
    code["8"] = patterns.find { |pat| pat.size == 7 }
    
    fives = patterns.find_all { |pat| pat.size == 5 }
    code["3"] = fives.find { |pat| (code["1"] - pat).empty? }
    code["2"] = fives.find { |pat| (pat - code["7"] - code["4"]).size == 2 }
    code["5"] = fives.find { |pat| (pat - code["2"]).size == 2 }
    
    sixes = patterns.find_all { |pat| pat.size == 6 }
    code["9"] = sixes.find { |pat| (code["4"] - pat).empty? }
    code["0"] = sixes.find { |pat| (code["5"] - pat).size == 1 }
    code["6"] = sixes.find { |pat| (pat - code["7"]).size == 4 }
  end
  
  def output_value
    @output.map { |pattern| code.invert[pattern] }.join
  end    
end
