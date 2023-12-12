module Day06
  class << self
    def title
      'Wait For It'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      boat = Boat.new
      Race.parse(input).map { |race| race.ways_to_beat_record boat }.reduce :*
    end
    
    def solve_part_two input
      boat = Boat.new
      OneRace.parse(input).ways_to_beat_record boat
    end
  end
  
  class Race
    class << self
      def parse string
        lines = string.split "\n"
        table = lines.map { |line| line.scan(/\d+/).map &:to_i }.transpose
        table.map { |time, record| self.new time, record }
      end
    end
    
    def initialize time, record_distance
      @time            = time
      @record_distance = record_distance
    end
    
    attr_reader :time
    attr_reader :record_distance
    
    def ways_to_beat_record boat
      max = boat.max_charge_time_to_beat_record time, record_distance
      min = boat.min_charge_time_to_beat_record time, record_distance
      max - min
    end
  end
  
  class OneRace < Race
    class << self
      def parse string
        lines        = string.split "\n"
        time, record = lines.map { |line| line.scan(/\d+/).join.to_i }
        self.new time, record
      end
    end
  end
  
  class Boat
    def initialize
      @starting_speed = 0
      @charge_rate    = 1
    end
    
    attr_reader :starting_speed
    attr_reader :charge_rate
    
    def speed charge_time
      starting_speed + charge_rate * charge_time
    end
    
    def distance race_time, charge_time
      speed(charge_time) * (race_time - charge_time)
    end
    
    def min_charge_time_to_beat_record race_time, record_distance
      bsearch(0, race_time / 2) do |charge_time|
        distance(race_time, charge_time) > record_distance
      end
    end
    
    def max_charge_time_to_beat_record race_time, record_distance
      bsearch(race_time / 2 + 1, race_time) do |charge_time|
        distance(race_time, charge_time) <= record_distance
      end
    end
    
    private
    
    def bsearch lower, upper, &condition
      until upper - lower == 1
        mid = (upper - lower) / 2 + lower
        condition.call(mid) ? upper = mid : lower = mid
      end
      upper
    end
  end
end
