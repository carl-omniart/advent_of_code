module Day12
  class << self
    def title
      'Hot Springs'
    end
    
    def day
      name.gsub('Day', '').to_i
    end
    
    def solve_part_one input
      records = input.split("\n").map { |line| Record.parse line }
      records.map(&:different_arrangements).sum
    end
    
    def solve_part_two input
      records = input.split("\n").map { |line| FoldedRecord.parse line }
      records.map(&:different_arrangements).sum
    end
  end
  
  class Spring
    @instances = []
    class << self
      attr_reader :instances
      
      def new *args, **opts, &block
        super(*args, **opts, &block).tap do |spring|
          instances << spring
          define_method(:"#{spring.status}?") { spring.status == send(:status) }
        end
      end
      
      def fetch key
        case key
        when String
          instances.find { |spring| key == spring.char }
        when Symbol
          instances.find { |spring| key == spring.status }
        end
      end
    end
    
    def initialize char, status
      @char   = char
      @status = status
    end
    
    attr_reader :char
    attr_reader :status
    
    alias_method    :to_s, :char
    alias_method :inspect, :char
  end
  
  class Row
    SPRINGS = {
      operational: ".",
      damaged:     "#",
      unknown:     "?"
    }.map { |status, char| [status, Spring.new(char, status)] }.to_h
    
    class << self
      def parse input
        springs = input.each_char.map { |char| Spring.fetch char }
        self.new *springs
      end
    end
    
    def initialize *springs
      @springs = springs
    end
    
    attr_reader :springs
    
    def to_s
      springs.map(&:to_s).join
    end
    
    alias_method :inspect, :to_s
    
    def empty?
      springs.empty?
    end
    
    def has? *statuses
      springs.any? { |spring| statuses.include? spring.status }
    end
    
    def first
      springs.first
    end
    
    def ltrim n
      self.class.new *springs[n..-1]
    end
    
    def ltrim_while status
      n = springs.index { |spring| spring.status != status }
      ltrim n
    end
    
    def can_begin_with_damaged? n
      return false if n > springs.size
      return false if springs.take(n).any? &:operational?
      return false if springs[n].damaged? unless n == springs.size
      true
    end
    
    def substitute status
      first_spring = Spring.fetch(status)
      last_springs = springs[1..-1]
      self.class.new first_spring, *last_springs
    end
  end
  
  class List
    class << self
      def parse input
        lengths = input.split(",").map &:to_i
        self.new *lengths
      end
    end
    
    def initialize *lengths
      @lengths = lengths
    end
    
    attr_reader :lengths
    
    alias_method :to_a, :lengths
    
    def inspect
      to_a.inspect
    end
    
    def empty?
      lengths.empty?
    end
    
    def first
      lengths.first
    end
    
    def ltrim n
      self.class.new *lengths[n..-1]
    end
  end
  
  class Record
    class << self
      def parse input
        front, back = input.split " "
        self.new Row.parse(front), List.parse(back)
      end
      
      def different_arrangements record
        @cache      ||= {}
        key           = [record.row.to_s, record.list.to_a]
        @cache[key] ||= calc_different_arrangements(record)
      end
      
      private
      
      def calc_different_arrangements record
        if record.list.empty?
          return 0 if record.row.has? :damaged
          return 1
        else
          return 0 unless record.row.has? :damaged, :unknown
        end
        
        spring = record.row.first
        length = record.list.first
        
        case spring.status
        when :operational
          row  = record.row.ltrim_while :operational
          list = record.list
          different_arrangements self.new(row, list)
        when :damaged
          if record.row.can_begin_with_damaged? length
            row  = record.row.ltrim length + 1
            list = record.list.ltrim 1
            different_arrangements self.new(row, list)
          else
            return 0
          end
        when :unknown
          [:operational, :damaged].map do |status|
            row  = record.row.substitute status
            list = record.list
            different_arrangements self.new(row, list)
          end.sum
        end
      end
    end
    
    def initialize row, list
      @row  = row
      @list = list
    end
    
    attr_reader :row
    attr_reader :list
    
    def different_arrangements
      self.class.different_arrangements self
    end
  end
  
  class FoldedRecord < Record
    class << self
      def parse input
        front, back = input.split " "
        front       = ([front] * 5).join Spring.fetch(:unknown).char
        back        = ([ back] * 5).join ","
        self.new Row.parse(front), List.parse(back)
      end
    end
  end
end
