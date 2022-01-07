class Sonar
  def self.parse input
    depths = input.strip.split("\n").map { |line| line.strip.to_i }
    self.new *depths
  end
  
  def initialize *depths
    @depths = depths
  end
  
  attr_reader :depths
  
  def increase_count *measurements
    measurements.each_cons(2).count { |near, far| far > near }
  end

  def depths_increase_count
    increase_count *depths
  end
  
  def sliding_window_sums window_width
    depths.each_cons(window_width).map &:sum
  end
  
  def sliding_window_sums_increase_count window_width
    increase_count *sliding_window_sums(window_width)
  end  
end
