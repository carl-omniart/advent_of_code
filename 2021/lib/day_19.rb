class Coords
  include Enumerable
  
  class << self
    def sum a, b
      raise ArgumentError unless a.size == b.size
      a.zip(b).map &:sum
    end
    
    def difference a, b
      raise ArgumentError unless a.size == b.size
      a.zip(b).map { |aa, bb| aa - bb }
    end
    
    alias_method :diff, :difference
    
    def magnitude a
      a.inject { |x, y| Math.sqrt(x**2 + y**2) }
    end
    
    def distance_between a, b
      magnitude difference(a, b)
    end
    
    def manhattan_distance a, b
      difference(a, b).map(&:abs).sum
    end
    
    alias_method :dist_between, :distance_between
  end
  
  def initialize *ary
    raise ArgumentError unless ary.all? { |n| n.is_a? Numeric }
    @ary = ary
  end
  
  attr_reader :ary
  
  def to_a
    ary
  end
  
  def each
    return enum_for(:each) unless block_given?
    ary.each { |n| yield n }
  end
  
  def to_s
    ary.to_s
  end
  
  alias_method :inspect, :to_s
  
  def size
    ary.size
  end
  
  def == other
    return false unless other.respond_to? :to_a
    to_a == other.to_a
  end
  
  def <=> other
    return false unless other.respond_to? :to_a
    to_a <=> other.to_a
  end
  
  def [] index
    to_a[index]
  end
  
  def + other
    sum = self.class.sum self, other
    self.class.new *sum
  end
  
  def - other
    diff = self.class.difference self, other
    self.class.new *diff
  end
  
  def magnitude
    self.class.magnitude self
  end
  
  def distance_to other
    self.class.distance_between self, other
  end
  
  alias_method :dist_to, :distance_to
  
  def abs_max
    ary.map(&:abs).max
  end
  
  def abs_min
    ary.map(&:abs).min
  end
end

class Orientation
  def initialize desc
    polarities, axes = desc.scan(/([-+])(\d+)/).transpose
    @polarities      = polarities.map { |pol| "#{pol}1".to_i }
    @axes            = axes.map &:to_i
  end
  
  attr_reader :axes
  attr_reader :polarities
  
  def desc
    str_pols = polarities.map { |pol| pol.positive? ? "+" : "-" }
    str_axes = axes.map &:to_s
    
    str_pols.zip(str_axes).map(&:join).join
  end
  
  def to_s
    "<#{self.class}: #{desc}>"
  end
  
  alias_method :inspect, :to_s
  
  def matrix
    axes.zip polarities
  end
  
  def each
    return enum_for(:each) unless block_given?
    matrix.each { |axis, polarity| yield axis, polarity }
  end
  
  def size
    matrix.size
  end
  
  def transform other
    raise ArgumentError unless size == other.size
    matrix.map { |axis, polarity| other[axis] * polarity }
  end
end

class Scanner
  ORIENTATIONS = %w(
    +0+1+2 +0-2+1 +0-1-2 +0+2-1 -0+1-2 -0+2+1 -0-1+2 -0-2-1
    +1-0+2 +1-2-0 +1+0-2 +1+2+0 -1+0+2 -1-2+0 -1-0-2 -1+2-0
    +2+1-0 +2+0+1 +2-1+0 +2-0-1 -2+1+0 -2-0+1 -2-1-0 -2+0-1
  ).map { |desc| Orientation.new desc }

  DEFAULTS = {
    coords:      [0, 0, 0],
    range:       1_000,
    orientation: ORIENTATIONS.first
  }
  
  def self.each_orientation
    return enum_for(:each_orientation) unless block_given?
    ORIENTATIONS.each { |orientation| yield orientation }
  end
  
  def initialize **args
    args = DEFAULTS.merge args
    
    @coords      = args[:coords]
    @range       = args[:range]
    @orientation = args[:orientation]
    @beacons     = []
  end
  
  attr_accessor :coords
  attr_accessor :range
  attr_accessor :orientation
  
  def beacons
    @beacons.map { |rel_coords| orientation.transform rel_coords }
  end
  
  def absolute_beacons
    beacons.map { |rel_coords| Coords.sum coords, rel_coords }
  end
  
  def add_beacon *rel_coords
    @beacons << rel_coords if detects_relative? *rel_coords
    self
  end
  
  def to_s
    "<#{self.class} #{coords} range: #{range} beacons: #{beacons_count}>"
  end
  
  alias_method :inspect, :to_s
  
  def beacons_count
    @beacons.size
  end
  
  def detects_relative? *rel_coords
    Coords.new(*rel_coords).abs_max <= range
  end
  
  def detects_absolute? *abs_coords
    detects_relative? *Coords.difference(abs_coords, coords)
  end

  def ranges
    coords.map { |n| n - range..n + range }
  end
  
  def overlaps? other
    ranges.zip(other.ranges).all? { |a, b| a.cover?(b.min) || b.cover?(a.min) }
  end

  def beacon_distances
    beacons.map { |a| beacons.map { |b| Coords.dist_between(a, b).round 2 } }
  end
  
  def beacons_detected_by scanner
    absolute_beacons.select do |abs_coords|
      scanner.detects_absolute? *abs_coords
    end
  end
  
  def beacons_in_all_orientations
    self.class.each_orientation.map do |o|
      beacons.map { |rel_coords| o.transform(rel_coords) }
    end
  end
  
  def aligned_with? scanner
    a = self.beacons_detected_by scanner
    b = scanner.beacons_detected_by self
    result = a.size >= 12 && a.sort == b.sort
  end
  
  def align_with scanner
    each_alignment(scanner).any? { aligned_with? scanner }
  end
  
  private
  
  def each_alignment scanner
    return enum_for(:each_alignment, scanner) unless block_given?

    each_beacon_match(scanner) do |flex, fixed|
      fixed_coords = Coords.sum scanner.coords, scanner.beacons[fixed]
      
      self.class.each_orientation.map do |new_orientation|
        self.orientation = new_orientation
        self.coords      = Coords.difference fixed_coords, beacons[flex]
        yield
      end
    end
  end
  
  def each_beacon_match scanner
    return enum_for(:each_beacon_match, scanner) unless block_given?
    flex_chart  = self.beacon_distances
    fixed_chart = scanner.beacon_distances
    
    flex_chart.each_with_index do |flex_distances, flex|
      fixed_chart.each_with_index do |fixed_distances, fixed|
        yield flex, fixed if (flex_distances & fixed_distances).size >= 11
      end
    end
  end
end

class RegionMap
  def self.parse input
    lines = input.strip.split("\n").map &:strip
    
    scanners = []

    lines.reject(&:empty?).each do |line|
      if line =~ /^--- scanner \d+ ---$/
        scanners << Scanner.new
      else
        scanner = scanners.last
        coords  = line.split(",").map &:to_i
        scanner.add_beacon *coords
      end
    end
    
    scanner = scanners.shift
    self.new(scanner) { |region_map| region_map.add_scanners *scanners }
  end

  def initialize scanner
    @scanners = [scanner]
    @queue    = []
    yield self if block_given?
  end
  
  attr_reader :scanners
  
  def aligned_scanners
    scanners - queue
  end

  def add_scanner new_scanner
    @scanners << new_scanner
    @queue.unshift new_scanner
    check_queue
  end
  
  def add_scanners *scanners
    scanners.each { |scanner| add_scanner scanner }
    self
  end
  
  def beacons
    aligned_scanners.map(&:absolute_beacons).inject &:|
  end
  
  def beacon_count
    beacons.size
  end
  
  def manhattan_distances
    scanners.combination(2).map do
      |a, b| Coords.manhattan_distance a.coords, b.coords
    end
  end

  private
  
  attr_reader :queue
  
  def check_queue
    newly_aligned = queue.select do |unaligned|
      aligned_scanners.reverse.any? { |aligned| unaligned.align_with aligned }
    end
    
    @queue -= newly_aligned
    check_queue unless newly_aligned.empty?    
  end
end
