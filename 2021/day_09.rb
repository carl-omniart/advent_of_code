class HeightMap
  def initialize *entries
    @map = entries.map { |entry| entry.chars.map &:to_i }
    
    @max_x = @map.first.size - 1
    @max_y = @map.size - 1
  end
  
  attr_reader :max_x
  attr_reader :max_y
  
  def each_point
    return enum_for(:each_point) unless block_given?
    @map.each_with_index { |row, y| row.each_index { |x| yield x, y } }
  end
  
  def height_at x, y
    @map[y][x]
  end
  
  def each_neighbor x, y
    return enum_for(:each_neighbor, x, y) unless block_given?
    yield [x - 1, y] unless x == 0
    yield [x + 1, y] unless x == max_x
    yield [x, y - 1] unless y == 0
    yield [x, y + 1] unless y == max_y
  end
  
  def low_point? x, y
    height = height_at x, y
    each_neighbor(x, y).all? { |neighbor| height < height_at(*neighbor) }
  end
  
  def low_points
    @low_points ||= each_point.select { |point| low_point? *point }
  end
  
  def risk_level x, y
    height_at(x, y) + 1
  end
  
  def risk_levels
    low_points.map { |x, y| risk_level x, y }
  end
  
  def risk_level_sum
    risk_levels.sum
  end
  
  def points_in_basins
    each_point.reject { |point| height_at(*point) == 9 }
  end
  
  def basins
    @basins ||= [].tap do |basins|
      points = points_in_basins
      
      until points.empty?
        point = points.first
        basins << find_basin(*point)
        points -= basins.last
      end
    end
  end
  
  def find_basin x, y
    basin = []
    rim   = ([] << [x, y])
    
    until rim.empty?
      basin += rim
      rim = expand_rim basin, rim
    end
    
    basin
  end
  
  def expand_rim basin, rim
    rim.flat_map do |point|
      each_neighbor(*point).reject do |neighbor|
        basin.include?(neighbor) || height_at(*neighbor) == 9
      end
    end.uniq
  end
  
  def basin_sizes
    basins.map &:size
  end
  
  def basin_sizes_from_smallest_to_largest
    basin_sizes.sort
  end
  
  def three_largest_basin_sizes
    basin_sizes_from_smallest_to_largest.last 3
  end
  
  def product_of_three_largest_basin_sizes
    three_largest_basin_sizes.inject :*
  end
end
