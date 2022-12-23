module SupplyStacks
  class << self
    def parse string, crate_mover_model: 9000
      lines       = parse_by_type lines_with_content(string)
      columns     = parse_columns lines[:columns].first
      stacks      = parse_stacks lines[:rows], columns
      procedures   = lines[:procedures].map { |line| parse_procedure line }
      crane       = Crane.new procedures: procedures, model: crate_mover_model
      
      Dock.new do |d|
        d.stacks = stacks
        d.crane  = crane
      end
    end
    
    def lines_with_content string
      string.split("\n").select { |line| line =~ /\S/ }
    end
    
    def parse_by_type lines
      types = { "[" => :rows, "1" => :columns, "m" => :procedures }
      lines.chunk { |line| types[line.match(/\S/)[0]] }.to_h
    end
    
    def parse_columns line
      line.scan(/\d+/).map { |column| line =~ /#{column}/ }
    end
    
    def parse_stacks rows, columns
      columns.map do |col|
        crates = parse_crates rows, col
        Stack.new *crates
      end
    end
    
    def parse_crates rows, col
      rows.map { |row| row[col] }.reject { |crate| crate == " " || crate.nil? }
    end
    
    def parse_procedure line
      values = line.match(/move (\d+) from (\d+) to (\d+)/)[1, 3].map &:to_i
      [:move, :from, :to].zip(values).to_h.tap do |h|
        h[:from] -= 1
        h[:to]   -= 1
      end
    end
  end
  
  class Dock
    def initialize
      yield self if block_given?
    end
    
    attr_accessor :stacks
    attr_accessor :crane
    
    def rearrange_stacks!
      crane.rearrange! stacks
      self
    end
  end
  
  class Stack
    def initialize *crates
      @crates = crates
    end
    
    attr_reader :crates
    
    def top_crate
      crates.first
    end
    
    def take this_many_crates
      crates.shift this_many_crates
    end
    
    def add these_crates
      crates.unshift *these_crates
    end
  end
  
  class Crane
    def initialize procedures: [], model: 9000
      @procedures = procedures
      @model      = model
    end
    
    attr_reader :procedures
    attr_reader :model
    
    def rearrange! stacks
      procedures.each do |procedure|
        quantity = procedure[:move]
        from     = procedure[:from]
        to       = procedure[:to]
        
        crates = stacks[from].take(quantity)
        crates.reverse! if model == 9000
        stacks[to].add crates
      end
    end
  end
end