class Target
  def initialize left, right, bottom, top
    @left   = left
    @right  = right
    @top    = top
    @bottom = bottom
  end
  
  attr_reader :left
  attr_reader :right
  attr_reader :top
  attr_reader :bottom
  
  def in_area? x, y
    x.between?(left, right) && y.between?(bottom, top)
  end
end

class Probe
  def initialize x_vel, y_vel
    @x     = 0
    @y     = 0
    @x_vel = x_vel
    @y_vel = y_vel
  end
  
  attr_reader :x
  attr_reader :y
  attr_reader :x_vel
  attr_reader :y_vel
  
  def step
    @x += x_vel
    drag!

    @y += y_vel
    gravity!
    
    self
  end
  
  def hit? target
    until y < target.bottom
      step
      return true if target.in_area? x, y
    end
    false
  end
  
  def max_y
    step until y_vel == 0
    y
  end
  
  private
  
  def drag!
    drag    = (x_vel <=> 0)
    @x_vel -= drag
  end
  
  def gravity!
    @y_vel -= 1
  end
end

class Launcher
  def self.parse input
    x_range, y_range = input.scan /[\d-]+\.\.[\d-]+/
    left, right  = x_range.split("..").map &:to_i
    bottom, top  = y_range.split("..").map &:to_i

    target = Target.new left, right, bottom, top
    self.new target
  end
  
  def initialize target
    @target = target
  end
  
  attr_reader :target
  
  def min_y_vel
    target.bottom
  end
  
  def max_y_vel
    -(target.bottom + 1)
  end
  
  def min_x_vel
    find_pyramid_number target.left
  end
  
  def max_x_vel
    target.right
  end
  
  def max_y
    Probe.new(min_x_vel, max_y_vel).max_y
  end
  
  def all_initial_velocities
    each_potential_velocity.select do |x_vel, y_vel|
      Probe.new(x_vel, y_vel).hit?(target)
    end
  end
  
  private
  
  def find_pyramid_number mark
    sum = 0
    1.upto(mark) do |n|
      sum += n
      return n if sum >= mark
    end
    nil
  end
  
  def each_potential_velocity
    return enum_for(:each_potential_velocity) unless block_given?
    min_y_vel.upto(max_y_vel) do |y_vel|
      min_x_vel.upto(max_x_vel) { |x_vel| yield x_vel, y_vel }
    end
  end
end
