class Diagnostic
  def self.parse input
    report = input.strip.split("\n").map &:strip
    report = report.map { |binary| binary.chars.map &:to_i }

    self.new report
  end

  def initialize report
    @report = report
  end
  
  attr_reader :report
  
  def each_row
    return enum_for(:each_row) unless block_given?
    report.each { |row| yield row }
  end
  
  def each_column
    return enum_for(:each_column) unless block_given?
    report.transpose.each { |column| yield column }
  end
  
  def gamma_rate
    bin_ary = each_column.map { |column| most_common_bit column }
    bin_ary_to_int bin_ary
  end
  
  def epsilon_rate
    bin_ary = each_column.map { |column| least_common_bit column }
    bin_ary_to_int bin_ary
  end
  
  def power_consumption
    gamma_rate * epsilon_rate
  end
  
  def oxygen_generator_rating
    filter(report) { |column| most_common_bit column, 1 }
  end
  
  def co2_scrubber_rating
    filter(report) { |column| least_common_bit column, 0 }
  end
  
  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end
  
  private
  
  def frequency ary
    Hash[[0, 1].map { |bit| [bit, ary.count(bit)] }]
  end
  
  def most_common_bit ary, tie = :shrug
    freq = frequency ary
    return tie if freq[0] == freq[1]
    freq[0] > freq[1] ? 0 : 1
  end
  
  def least_common_bit ary, tie = :shrug
    freq = frequency ary
    return tie if freq[0] == freq[1]
    freq[0] > freq[1] ? 1 : 0
  end
  
  def bin_ary_to_int bin_ary
    bin_ary.reverse.each_with_index.inject(0) { |sum, (b, i)| sum + b * 2**i }
  end

  def filter ary, pos = 0, &bit_criteria
    column    = ary.map { |binary| binary[pos] }
    bit       = bit_criteria.call column
    remaining = ary.select { |binary| binary[pos] == bit }
    
    if remaining.size == 1
      bin_ary_to_int remaining.last
    else
      filter remaining, pos + 1, &bit_criteria
    end
  end  
end
