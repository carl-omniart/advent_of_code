class Submarine
  def initialize
    @pos    = 0
    @depth  = 0
  end
  
  attr_reader :pos
  attr_reader :depth
  
  def forward x
    @pos += x
  end
  
  def up x
    @depth -= x
  end
  
  def down x
    @depth += x
  end
  
  def set_course input
    parse(input).each { |command, value| self.send command, value }
    self
  end
  
  private
  
  def parse input
    input = input.strip.split("\n").map { |line| line.strip.split " " }
    input.map { |command, value| [command.to_sym, value.to_i] }
  end
end

class AimingSubmarine < Submarine
  def initialize
    @aim = 0
    super
  end
  
  attr_reader :aim
  
  def forward x
    @depth += aim * x
    super
  end
  
  def up x
    @aim -= x
  end
  
  def down x
    @aim += x
  end
end
