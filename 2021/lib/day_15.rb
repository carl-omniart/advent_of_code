class Position
  def initialize risk
    @risk       = risk
    @neighbors  = []
    @total_risk = Float::INFINITY
  end
  
  attr_reader :risk
  attr_reader :previous
  attr_reader :total_risk
  
  def connect neighbor
    return self if @neighbors.include? neighbor
    @neighbors << neighbor
    neighbor.connect self
    self
  end
  
  def each_neighbor
    return enum_for(:each_neighbor) unless block_given?
    @neighbors.each { |neighbor| yield neighbor }
  end
  
  def neighbors
    each_neighbor.to_a
  end
  
  def start!
    @total_risk = 0
  end
  
  def extend_path_to_neighbors
    each_neighbor.select { |neighbor| neighbor.extend_path_from self }
  end
  
  def extend_path_from neighbor
    new_risk = neighbor.total_risk + risk
    
    if new_risk < total_risk
      @total_risk = new_risk
      @previous   = neighbor
      true
    else
      false
    end
  end
end

class Cavern
  def self.parse input
    grid = input.strip.split("\n").map { |line| line.strip.chars.map &:to_i }
    self.new grid
  end

  def initialize grid
    @cavern = graph grid
  end
  
  attr_reader :cavern
  
  def origin
    cavern.first
  end
  
  def destination
    cavern.last
  end
  
  def calculate_total_risk
    origin.start!
    
    visited   = []
    queue     = cavern.select { |pos| pos.total_risk < Float::INFINITY }
    
    until queue.empty?
      pos = queue.min_by &:total_risk
      visited << queue
      queue.delete pos
      
      queue += pos.extend_path_to_neighbors
    end

    self
  end
  
  def lowest_risk_path
    path = ([] << destination)
    path << path.last.previous until path.last == origin
    path.reverse
  end
  
  def lowest_total_risk
    destination.total_risk
  end
  
  private
  
  def graph grid
    grid.map! { |row| row.map { |risk| Position.new risk } }
    
    grid.each           { |row| row.each_cons(2) { |a, b| a.connect b } }
    grid.transpose.each { |col| col.each_cons(2) { |a, b| a.connect b } }
    
    grid.flatten
  end
end

class BigCavern < Cavern
  def initialize grid
    grid.map! do |row|
      0.upto(4).flat_map { |n| row.map { |val| (val - 1 + n) % 9 + 1 } }
    end
    
    grid = grid.transpose.map do |col|
      0.upto(4).flat_map { |n| col.map { |val| (val - 1 + n) % 9 + 1 } }
    end
    
    @cavern = graph grid
  end   
end
