class Packet
  def self.parse_hex hex
    parse_bin hex_to_bin(hex)
  end
  
  def self.parse_bin bin
    version = bin.slice!(0, 3).to_i(2)
    type_id = bin.slice!(0, 3).to_i(2)
    
    case type_id
    when 4
      LiteralValue.new version, type_id, bin
    else
      Operator.new version, type_id, bin
    end
  end
  
  def self.hex_to_bin hex
    hex.each_char.map { |char| char.to_i(16).to_s(2).rjust(4, "0") }.join
  end

  def initialize version, type_id
    @version = version
    @type_id = type_id
  end
  
  attr_reader :version
  attr_reader :type_id
  
  def type
    case type_id
    when 4
      :literal_value
    else
      :operator
    end
  end
end

class LiteralValue < Packet
  def initialize version, type_id, bin
    super version, type_id
    @value = get_value bin
  end
  
  attr_reader :value
  
  def version_sum
    version
  end

  private
    
  def get_value bin
    value = ""
    flag  = true
    
    while flag
      flag   = bin.slice!(0) == "1"
      group  = bin.slice! 0, 4
      value += group
    end
    
    value.to_i 2
  end
end

class Operator < Packet
  def initialize version, type_id, bin
    super version, type_id

    @length_type_id = bin.slice!(0).to_i
    @subpackets     = get_subpackets bin
  end

  attr_reader :length_type_id
  attr_reader :subpackets
  
  def values
    subpackets.map &:value
  end
  
  def value
    case type
    when :sum
      values.sum
    when :product
      values.inject :*
    when :minimum
      values.min
    when :maximum
      values.max
    when :greater_than
      values.first > values.last ? 1 : 0
    when :less_than
      values.first < values.last ? 1 : 0
    when :equal_to
      values.first == values.last ? 1 : 0
    end      
  end
  
  def type
    case type_id
    when 0
      :sum
    when 1
      :product
    when 2
      :minimum
    when 3
      :maximum
    when 5
      :greater_than
    when 6
      :less_than
    when 7
      :equal_to
    end
  end
  
  def version_sum
    version + subpackets.map(&:version_sum).sum
  end
  
  def length_type
    case length_type_id
    when 0
      :total_length_in_bits
    when 1
      :number_of_subpackets
    end
  end
  
  private
  
  def get_subpackets bin
    subpackets = []
    case length_type
    when :total_length_in_bits
      length_in_bits  = bin.slice!(0, 15).to_i(2)
      bits            = bin.slice!(0, length_in_bits)  
      subpackets << Packet.parse_bin(bits) until bits.empty?
    when :number_of_subpackets
      subpacket_count = bin.slice!(0, 11).to_i(2)
      1.upto(subpacket_count) { subpackets << Packet.parse_bin(bin) }
    end
    subpackets
  end
end
