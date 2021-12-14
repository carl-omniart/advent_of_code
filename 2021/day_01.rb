class InputWrapper
  DAY = 1
  
  def self.load
    file_name = "day_%02d_input.txt" % DAY
    self.new File.read(file_name)
  end
  
  def initialize input
    @depths = input.strip.split("\n").map(&:strip).map(&:to_i)
  end
  
  attr_reader :depths
end

class Sonar
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

def solve_part_one
  input = InputWrapper.load
  sonar = Sonar.new *input.depths
  
  count = sonar.depths_increase_count
  puts "1. The number of times that depth measurements increase is #{count}."
end

def solve_part_two
  input = InputWrapper.load
  sonar = Sonar.new *input.depths
  
  count = sonar.sliding_window_sums_increase_count 3
  puts "2. The number of times that sliding window sums increase is #{count}."
end

solve_part_one
solve_part_two