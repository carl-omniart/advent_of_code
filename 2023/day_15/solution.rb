module Day15
  class << self
    def title
      'Lens Library'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      steps = input.strip.split ","
      steps.map { |step| HASH.calc step }.sum
    end
    
    def solve_part_two input
      HASHMAP.parse(input).focusing_power
    end
  end
  
  class HASH
    def self.calc string
      string.each_byte.reduce(0) { |val, byte| (val + byte) * 17 % 256 }
    end
  end
  
  class Box
    def initialize id
      @id     = id
      @lenses = []
    end
    
    attr_reader :id
    attr_reader :lenses
    
    def remove label
      lenses.delete_if { |lens| lens.label == label }
      self
    end

    def add lens
      i = lenses.index { |l| l.label == lens.label }
      i ? lenses[i] = lens : lenses << lens
      self
    end
    
    def focusing_power
      lenses.each.with_index(1).reduce(0) do |sum, (lens, i)|
        sum + (id + 1) * i * lens.focal_length
      end
    end
  end
  
  class Lens
    def initialize label, focal_length
      @label        = label
      @focal_length = focal_length
    end
    
    attr_reader :label
    attr_reader :focal_length
  end
  
  class HASHMAP
    class << self
      def parse input
        boxes = (0..255).map { |id| Box.new id }
        self.new(*boxes) { |h| each_step(input) { |*step| h.execute *step } }   
      end
      
      def each_step input
        input.strip.split(",").each do |string|
          match = string.match /^(?<l>\w+)(?<o>[-=])(?<fl>\d*)$/
          label, operator, focal_length = match.values_at :l, :o, :fl
          yield label, operator, focal_length.to_i
        end
      end
    end
    
    def initialize *boxes
      @boxes = boxes.map { |box| [box.id, box] }.to_h
      yield self if block_given?
    end
    
    attr_reader :boxes
    
    def box_labeled label
      boxes[HASH.calc(label)]
    end
    
    def execute label, operator, focal_length
      box = box_labeled label
      case operator
      when "-"
        box.remove label
      when "="
        lens = Lens.new label, focal_length
        box.add lens
      end
      self
    end
    
    def focusing_power
      boxes.each_value.map(&:focusing_power).sum
    end
  end
end
