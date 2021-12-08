class Submarine
  def initialize
    @position = 0
    @depth    = 0
  end
  
  attr_reader :position
  attr_reader :depth
  
  def forward x
    @position += x
  end
  
  def up x
    @depth -= x
  end
  
  def down x
    @depth += x
  end
  
  def set_course *course
    course.each do |step|
      direction, x = step.split " "
      self.send direction.to_sym, x.to_i
    end
    self
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

file_path = Dir.pwd + "/day_02_input.txt"
input = File.readlines(file_path).map &:strip

red_december = Submarine.new
red_december.set_course *input
position = red_december.position
depth    = red_december.depth

answer = position * depth
puts "1. The final horizontal position (#{position}) multiplied by the final depth (#{depth}) equals #{answer}."

red_december = AimingSubmarine.new
red_december.set_course *input
position = red_december.position
depth    = red_december.depth
answer   = position * depth

puts "2. The final horizontal position (#{position}) multiplied by the final depth (#{depth}) equals #{answer}."
