class Submarine

  def initialize *diagnostics
    @diagnostics = diagnostics
  end
  
  attr_reader :diagnostics
  
  def diagnostic_columns
    diagnostics.map(&:chars).transpose
  end
  
  def frequency array
    Hash[%w(0 1).map { |bit| [bit, array.count(bit)] }]
  end
  
  def most_common_bit array, tie = :shrug
    freq = frequency array
    case freq["1"] <=> freq["0"]
    when 1
      "1"
    when -1
      "0"
    else
      tie
    end
  end
  
  def least_common_bit array, tie = :shrug
    freq = frequency array
    case freq["1"] <=> freq["0"]
    when -1
      "1"
    when 1
      "0"
    else
      tie
    end
  end
  
  def binary_to_decimal binary_string
    binary_string.to_i 2
  end
  
  def gamma_rate
    binary = diagnostic_columns.map { |column| most_common_bit column }.join
    binary_to_decimal binary
  end
  
  def epsilon_rate
    binary = diagnostic_columns.map { |column| least_common_bit column }.join
    binary_to_decimal binary
  end  
  
  def power_consumption
    gamma_rate * epsilon_rate
  end
  
  def oxygen_generator_rating
    filter(diagnostics) { |column| most_common_bit column, "1" }
  end
  
  def co2_scrubber_rating
    filter(diagnostics) { |column| least_common_bit column, "0" }
  end
  
  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end
  
  
  def filter array, pos = 0, &bit_criteria
    column    = array.map { |binary| binary[pos] }
    bit       = bit_criteria.call column
    remaining = array.select { |binary| binary[pos] == bit }
    
    if remaining.size == 1
      binary_to_decimal remaining.last
    else
      filter remaining, pos + 1, &bit_criteria
    end
  end
end

file_name = Dir.pwd + "/day_03_input.txt"
diagnostic_report = File.readlines(file_name).map &:strip

red_december = Submarine.new *diagnostic_report

gamma   = red_december.gamma_rate
epsilon = red_december.epsilon_rate
power   = red_december.power_consumption

puts "1. Multiplying the gamma rating (#{gamma}) by the epsilon rating (#{epsilon}) equals a power consumption of #{power}."

oxygen        = red_december.oxygen_generator_rating
co2           = red_december.co2_scrubber_rating
life_support  = red_december.life_support_rating

puts "2. Multiplying the oxygen generator rating (#{oxygen}) by the co2 scrubber rating (#{co2}) equals a life support rating of #{life_support}."
