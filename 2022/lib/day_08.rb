module TreetopTreeHouse
  class << self
    def parse string
      rows = stripped_lines(string).map { |line| parse_tree_heights line }
      Forest.new *rows
    end
    
    def stripped_lines string
      string.strip.split("\n").map &:strip
    end
    
    def parse_tree_heights line
      line.each_char.map { |height| Tree.new height.to_i }
    end
  end
  
  class Tree
    def initialize height
      @height = height
    end
    
    attr_reader :height
  end
  
  class Forest
    DIRECTIONS = [
      :above,
      :right,
      :below,
      :left
    ]
    
    def initialize *rows
      @rows = rows
    end
    
    attr_reader :rows
    
    def columns
      rows.transpose
    end
    
    def tree x, y
      rows[y][x]
    end
    
    def left x, y
      before x, rows[y]
    end
    
    def right x, y
      after x, rows[y]
    end
    
    def above x, y
      before y, columns[x]
    end
    
    def below x, y
      after y, columns[x]
    end
    
    def before i, ary
      ary[0...i].reverse
    end
    
    def after i, ary
      ary[(i + 1)..-1]
    end

    def each_direction x, y
      return enum_for(:each_direction, x, y) unless block_given?
      DIRECTIONS.each { |dir| yield send(dir, x, y) }
    end
    
    def each_pos
      return enum_for(:each_pos) unless block_given?
      rows.each_with_index { |row, y| row.each_index { |x| yield x, y } }
    end
    
    def visible_tree_count
      each_pos.count { |x, y| visible? x, y }
    end
    
    def visible? x, y
      height = tree(x, y).height
      each_direction(x, y).any? do |outer_trees|
        outer_trees.all? { |outer_tree| height > outer_tree.height }
      end
    end
    
    def scenic_scores
      each_pos.map { |*pos| scenic_score *pos }
    end
    
    def scenic_score x, y
      viewing_distances(x, y).reduce :*
    end
    
    def viewing_distances x, y
      height = tree(x, y).height
      each_direction(x, y).map do |outer_trees|
        outer_heights = outer_trees.map &:height
        viewing_distance height, outer_heights
      end
    end
    
    def viewing_distance height, outer_heights
      outer_heights.reduce(0) do |distance, outer_height|
        distance += 1
        break distance if outer_height >= height
        distance
      end
    end
  end
end