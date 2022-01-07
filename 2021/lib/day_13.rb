class Dot
  def initialize x, y
    @x = x
    @y = y
    @visible_x = x
    @visible_y = y
  end
  
  def inspect
    "Dot at (#{x}, #{y})"
  end
  
  attr_reader :x
  attr_reader :y
  attr_reader :visible_x
  attr_reader :visible_y
  
  def get axis
    self.send axis
  end
  
  def get_visible axis
    self.send :"visible_#{axis}"
  end
  
  def set_visible axis, n
    self.send :"visible_#{axis}=", n
  end
  
  def fold_along axis, crease
    visible_n = get_visible axis
    return self unless visible_n > crease
    
    new_visible_n = 2 * crease - visible_n
    set_visible axis, new_visible_n

    self
  end
  
  private
  
  attr_writer :visible_x
  attr_writer :visible_y
end

class Paper
  def self.parse input
    input = input.strip.split("\n").map(&:strip).reject &:empty?
    dots, folds = input.partition { |line| line =~ /^\d/ }
    dots.map! { |line| line.split(",").map &:to_i }
    folds.map! { |line| line.delete("fold along ").split "=" }
    folds.map! { |axis, n| [axis.to_sym, n.to_i] }
    
    self.new dots, folds
  end
  
  def initialize dots, folds
    @dots  = dots.map { |x, y| Dot.new x, y }
    @folds = folds
  end
  
  attr_reader :dots
  
  def max_visible_x
    @dots.map(&:visible_x).max
  end
  
  def max_visible_y
    @dots.map(&:visible_y).max
  end
  
  def blank_grid
    Array.new(max_visible_y + 1) { "." * (max_visible_x + 1) }
  end
  
  def visible_dots
    blank_grid.tap do |g|
      dots.each { |dot| g[dot.visible_y][dot.visible_x] = "#" }
    end
  end
  
  def visible_dot_count
    dots.group_by { |dot| [dot.visible_x, dot.visible_y] }.keys.count
  end
  
  def fold
    axis, n = @folds.shift
    dots.each { |dot| dot.fold_along axis, n }
    self  
  end
  
  def fold_all
    fold until @folds.empty?
    self
  end
end