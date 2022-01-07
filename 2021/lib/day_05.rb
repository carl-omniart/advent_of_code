class Vent
  def self.parse input
    input.strip.split("\n").map(&:strip).map { |entry| self.new entry }    
  end
  
  def initialize entry
    @x1, @y1, @x2, @y2 = entry.scan(/\d+/).map &:to_i
  end
  
  attr_reader :x1, :y1, :x2, :y2
  
  def left
    [x1, x2].min
  end
  
  def right
    [x1, x2].max
  end
  
  def top
    [y1, y2].min
  end
  
  def bottom
    [y1, y2].max
  end
  
  def width
    right - left
  end
  
  def depth
    bottom - top
  end
  
  def vertical?
    x1 == x2
  end
  
  def horizontal?
    y1 == y2
  end
  
  def diagonal?
    width == depth
  end
  
  def x_range
    range = left.upto(right).to_a
    range.reverse! if x2 < x1
    range
  end
  
  def y_range
    range = top.upto(bottom).to_a
    range.reverse! if y2 < y1
    range
  end
    
  def points
    case
    when vertical?
      y_range.map { |y| [x1, y] }
    when horizontal?
      x_range.map { |x| [x, y1] }
    when diagonal?
      x_range.zip(y_range).map { |x, y| [x, y] }
    else
      :heck_if_i_know
    end
  end
end

class Diagram
  def initialize *vents
    width = vents.map(&:right).max
    depth = vents.map(&:bottom).max
    
    @diagram = Array.new(depth + 1) { Array.new(width + 1, 0) }
    
    vents.each { |vent| vent.points.each { |x, y| @diagram[y][x] += 1 } }
  end
  
  def to_s
    @diagram.map { |row| row.map(&:to_s).join.gsub "0", "." }.join "\n"
  end
  
  def dangerous_area_count
    @diagram.flatten.count { |point| point >= 2 }
  end
end
