class Sonar
  def initialize *measurements
    @measurements = measurements
  end
  
  attr_reader :measurements
  
  def window_sums
    measurements.each_cons(3).map &:sum
  end
  
  def depth_increase_count
    increase_count measurements
  end
  
  def window_sum_increase_count
    increase_count window_sums
  end
  
  def increase_count report
    report.each_cons(2).count { |a, b| b > a }
  end
end

file_path = Dir.pwd + "/day_01_input.txt"
input = File.readlines(file_path).map(&:strip).map(&:to_i)

sonar = Sonar.new *input

answer = sonar.depth_increase_count
puts "1. #{answer} measurements are larger than the previous measurement."

answer = sonar.window_sum_increase_count
puts "2. #{answer} sums are larger than the previous sum."
