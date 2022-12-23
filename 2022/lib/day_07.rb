module NoSpaceLeftOnDevice
  class << self
    def parse string
      disk = Disk.new
      dir  = disk.root
      
      terminal_output(string).each do |lines|
        command, arg = lines.shift.split " "
        
        case command
        when "cd"
          dir = dir.reverse_cd arg
        when "ls"
          dir.reverse_ls *lines
        end
      end
      
      disk
    end
    
    def terminal_output string
      stripped_lines(string).reduce([]) do |ary, line|
        if line.start_with? "$"
          ary << []
          line = line.gsub(/^\$/, "").strip
        end
        ary.last << line
        ary
      end
    end
    
    def stripped_lines string
      string.strip.split("\n").map &:strip
    end
  end
  
  class Disk
    DEFAULTS = {
      total_space: 70_000_000
    }

    def initialize **opts
      opts = DEFAULTS.merge opts
      
      @total_space   = opts[:total_space]
      @root         = Directory.new "/"      
    end
    
    attr_reader :root  
    attr_reader :total_space
    
    def used_space
      root.size
    end
    
    def unused_space
      total_space - used_space
    end
  end
  
  class Directory
    def initialize name
      @name  = name
      @dirs  = {}
      @files = {}
    end
    
    attr_reader :dirs
    attr_reader :files
    attr_reader :name

    attr_accessor :parent
  
    def size
      files.values.map(&:size).sum + dirs.values.map(&:size).sum
    end
    
    def add_dir dir
      dir.parent = self
      @dirs[dir.name] = dir
    end
    
    def add_file file
      @files[file.name] = file
    end
    
    def each_dir
      return enum_for(:each_dir) unless block_given?
      yield self
      dirs.each_value { |dir| dir.each_dir { |d| yield d } }
    end
    
    def reverse_cd arg
      new_dir =  case arg
                when "/"
                  parent.reverse_cd("/") unless parent.nil?
                when ".."
                  parent
                else
                  dirs[arg]
                end
      new_dir || self
    end          
    
    def reverse_ls *lines
      lines.each do |line|
        if line.start_with? "dir"
          _, name     = line.split " "
          add_dir Directory.new(name)
        else
          size, name   = line.split " "
          size         = size.to_i
          add_file File.new(name, size)
        end
      end
    end
  end
  
  class File
    def initialize name, size
      @name = name
      @size = size
    end
    
    attr_reader :name
    attr_reader :size
  end  
end