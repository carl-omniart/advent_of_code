class Cave
  def initialize name
    @name        = name
    @connections = []
  end
  
  attr_reader :name
  attr_reader :connections
  
  def inspect
    @name
  end
  
  def each_connection
    return enum_for(:each_connection) unless block_given?
    connections.each { |connection| yield connection }
  end
  
  def start?
    name == "start"
  end
  
  def end?
    name == "end"
  end
  
  def big?
    name == name.upcase
  end
  
  def small?
    name == name.downcase
  end
end

class CaveSystem
  def initialize input
    map = formatted input
    
    @caves = {}
    map.flatten.uniq.each { |name| @caves[name] = Cave.new name }
    map.each do |caves|
      caves.permutation { |a, b| @caves[a].connections << @caves[b] }
    end
  end
  
  def starting_cave
    @caves["start"]
  end
  
  def paths_that_visit_no_small_cave_twice
    each_path(starting_cave, :no_small_cave_twice).to_a
  end
  
  def paths_that_visit_one_small_cave_twice
    each_path(starting_cave, :one_small_cave_twice).to_a
  end
  
  def each_path *visited_caves, rule
    return enum_for(:each_path, *visited_caves, rule) unless block_given?
    
    visited_caves.last.each_connection.reject(&:start?).each do |cave|
      more_caves = (visited_caves.dup << cave)
      next if disallowed_path? more_caves, rule
      
      if cave.end?
        completed_path = caves_to_path more_caves
        yield completed_path
      else
        each_path(*more_caves, rule) { |path| yield path }
      end
    end
  end
  
  def disallowed_path? visited_caves, rule
    case rule
    when :no_small_cave_twice
      small_cave_twice_count(visited_caves) > 0
    when :one_small_cave_twice
      small_cave_twice_count(visited_caves) > 1 ||
      small_cave_more_than_twice?(visited_caves)
    else
      true
    end
  end
  
  def small_cave_twice_count caves
    caves.uniq.select { |cave| cave.small? && caves.count(cave) == 2 }.size
  end
  
  def small_cave_more_than_twice? caves
    caves.uniq.any? { |cave| cave.small? && caves.count(cave) > 2 }
  end
  
  def caves_to_path caves
    caves.map(&:name).join ","
  end
  
  private
  
  def formatted input
    input.strip.split("\n").map { |entry| entry.strip.split "-" }
  end
end
