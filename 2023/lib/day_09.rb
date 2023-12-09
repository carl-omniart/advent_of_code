module MirageMaintenance
  class OASIS
    def self.parse string
      lines = string.split "\n"
      self.new do |oasis|
        lines.each { |line| oasis.histories << History.parse(line) }
      end
    end
    
    def initialize
      @histories = []
      yield self if block_given?
    end
    
    attr_reader :histories
  end
  
  class History
    def self.parse string
      values = string.split(" ").map &:to_i
      self.new *values
    end
    
    def initialize *values
      @values = values
    end
    
    attr_reader :values
    
    def predicted_next_value
      difference_rows.reverse.reduce(0) { |value, row| value + row.last }
    end
    
    def predicted_prev_value
      difference_rows.reverse.reduce(0) { |value, row| row.first - value }
    end
    
    def difference_rows
      [values].tap do |rows|
        rows << differences(rows.last) until rows.last.all?(&:zero?)
      end
    end
    
    def differences row
      row.each_cons(2).map { |a, b| b - a }
    end      
  end
end
