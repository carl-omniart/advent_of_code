class Octopus
  def initialize energy
    @energy = energy.to_i
    @neighbors = []
  end
  
  attr_reader :energy
  attr_reader :neighbors
  
  def increase
    @energy += 1
    neighbors.each(&:increase) if flash?
  end
  
  def flash?
    energy == 10
  end
  
  def flashed?
    energy > 9
  end
  
  def reset
    @energy = 0
  end
end

class Octopi
  def initialize *rows
    @octopi = create_grid *rows
    
    @step        = 0
    @flash_count = 0
  end
  
  attr_reader :step
  attr_reader :flash_count
  
  def size
    @octopi.size
  end
  
  def each_octopus
    return enum_for(:each_octopus) unless block_given?
    @octopi.each { |octopus| yield octopus }
  end
  
  def advance
    each_octopus(&:increase).select(&:flashed?).tap do |flashers|
      @flash_count += flashers.size
      flashers.each &:reset
    end
    @step += 1
    self
  end
  
  def advance_to step
    (@step...step).each { advance }
    self
  end
  
  def advance_to_all_flash
    old_count = 0
    until flash_count - old_count == size
      old_count = flash_count
      advance
    end
  end
  
  private
  
  def create_grid *rows
    rows = rows.map { |row| row.chars.map { |energy| Octopus.new energy } }
    rows.each_with_index do |row, y|
      row.each_with_index do |octopus, x|
        each_neighbor(x, y, rows) { |neighbor| octopus.neighbors << neighbor }
      end
    end
    rows.flatten
  end
  
  def each_dxdy
    return enum_for(:dx_dy) unless block_given?
    d = [-1, 0, 1]
    d.each { |dx| d.each { |dy| yield [dx, dy] unless dx == 0 && dy == 0 } }
  end
  
  def each_neighbor x, y, rows
    each_dxdy do |dx, dy|
      xx, yy = x + dx, y + dy
      next if xx.negative? || yy.negative?
      next if yy == rows.size
      row = rows[yy]
      next if xx == row.size
      neighbor = row[xx]
      yield neighbor
    end
  end
end
