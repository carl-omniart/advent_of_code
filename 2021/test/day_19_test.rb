require 'minitest/autorun'
require 'day_19'

class CoordinatesTest < Minitest::Test
  def test_sums
    a = [0, 0, 0, 1, 2, 3, -4, -5,  -6]
    b = [0, 1,-2, 0, 3,-4,  0,  5,  -6]
    c = [0, 1,-2, 1, 5,-1, -4,  0, -12]
    
    assert_equal c, Coords.sum(a, b)
    assert_equal c, Coords.sum(b, a)

    assert_equal Coords.new(*c), Coords.new(*a) + b
    assert_equal Coords.new(*c), Coords.new(*b) + a

    assert_equal Coords.new(*c), Coords.new(*a) + Coords.new(*b)
    assert_equal Coords.new(*c), Coords.new(*b) + Coords.new(*a)
  end
  
  def test_differences
    a = [0, 0, 0, 1, 2, 3, -4, -5,  -6]
    b = [0, 1,-2, 0, 3,-4,  0,  5,  -6]
    c = [0,-1, 2, 1,-1, 7, -4, -10,  0]
    
    assert_equal c, Coords.difference(a, b)
    assert_equal b, Coords.difference(a, c)

    assert_equal c, Coords.diff(a, b)
    assert_equal b, Coords.diff(a, c)

    assert_equal Coords.new(*c), Coords.new(*a) - b
    assert_equal Coords.new(*b), Coords.new(*a) - c
    
    assert_equal Coords.new(*c), Coords.new(*a) - Coords.new(*b)
    assert_equal Coords.new(*b), Coords.new(*a) - Coords.new(*c)
  end
  
  def test_magnitude
    a = [3, -4]
    b = [3, -4, 12]
    
    assert_equal  5.0, Coords.magnitude(a).round(1)
    assert_equal 13.0, Coords.magnitude(b).round(1)
    
    assert_equal  5.0, Coords.new(*a).magnitude.round(1)
    assert_equal 13.0, Coords.new(*b).magnitude.round(1)
  end
  
  def test_distance_between
    [ [   [1, 2],     [4, -2],  5.0],
      [[1, 2, 3], [4, -2, 15], 13.0]
    ].each do |a, b, distance|
      assert_equal distance, Coords.distance_between(a, b).round(1)
      assert_equal distance, Coords.distance_between(b, a).round(1)
    
      assert_equal distance, Coords.dist_between(a, b).round(1)
      assert_equal distance, Coords.dist_between(b, a).round(1)
      
      assert_equal distance, Coords.new(*a).distance_to(b).round(1)
      assert_equal distance, Coords.new(*b).distance_to(a).round(1)
    
      assert_equal distance, Coords.new(*a).distance_to(Coords.new(*b)).round(1)
      assert_equal distance, Coords.new(*b).distance_to(Coords.new(*a)).round(1)
    
      assert_equal distance, Coords.new(*a).dist_to(Coords.new(*b)).round(1)
      assert_equal distance, Coords.new(*b).dist_to(Coords.new(*a)).round(1)
    end
  end
  
  def test_equality
    a = Coords.new -4, -1, 0,  1,  4
    b = Coords.new -4, -1, 0,  1,  4
    c = Coords.new  4,  1, 0, -1, -4
    
    assert a == b
    assert b == a
    refute a == c
    refute c == a
    refute b == c
    refute c == b
    
    assert a == [-4, -1, 0,  1, 4]
    assert c == [ 4,  1, 0, -1, -4]
  end
  
  def test_absolute_min_and_max
    a = Coords.new -9, 1, 5
    
    assert_equal 1, a.abs_min
    assert_equal 9, a.abs_max
  end
end

class OrientationTest < Minitest::Test
  def test_matrix
    orientation = Orientation.new "-1+2-0"
    assert_equal [-1,  1, -1], orientation.polarities
    assert_equal [ 1,  2,  0], orientation.axes
    assert_equal [[1, -1], [2, 1], [0, -1]], orientation.matrix
  end
  
  def test_transform
    orientation = Orientation.new "-1+2-0"
    
    a = [ 1,  2,  3]
    b = [-4,  0, -5]
    
    assert_equal [-2,  3, -1], orientation.transform(a)
    assert_equal [ 0, -5,  4], orientation.transform(b)
    assert_equal [-2,  3, -1], orientation.transform(Coords.new(*a))
    assert_equal [ 0, -5,  4], orientation.transform(Coords.new(*b))
  end
end

class ScannerTest < Minitest::Test
  def test_add_beacons
    scanner = Scanner.new coords: [0, 0, 0], range: 100
    
    [ [-100,    0,    0],
      [ 100,    0,    0],
      [   0, -100,    0],
      [   0,  100,    0],
      [   0,    0, -100],
      [   0,    0,  100]
    ].each { |coords| scanner.add_beacon *coords }
    
    assert_equal 6, scanner.beacons_count
    
    [ [-101,    0,    0],
      [ 101,    0,    0],
      [   0, -101,    0],
      [   0,  101,    0],
      [   0,    0, -101],
      [   0,    0,  101]
    ].each { |coords| scanner.add_beacon *coords }
    
    assert_equal 6, scanner.beacons_count
  end
  
  def test_range_and_overlap
    scanner = Scanner.new coords: [500, -500, 1000], range: 500
    
    assert_equal 500, scanner.range
    assert_equal [(0..1000), (-1000..0), (500..1500)], scanner.ranges
    
    [ [   0, -1000,  500],
      [1000,     0, 1500],
      [ 300,  -300, 1300]
    ].each { |near_coords| assert scanner.detects_absolute?(*near_coords) }
    
    [ [  -1, -1000,  500],
      [1000,     0, 1501],
      [ 300,    30, 1300]
    ].each { |far_coords| refute scanner.detects_absolute?(*far_coords) }
    
    near_scanner = Scanner.new coords: [1100, -1100, 1100], range: 100
    far_scanner  = Scanner.new coords: [1101, -1100, 1000], range: 100
    
    assert scanner.overlaps?(near_scanner)
    refute scanner.overlaps?(far_scanner)
  end
  
  def test_move_to
    scanner = Scanner.new coords: [0, -5, 10], range: 10
    assert_equal [0, -5, 10], scanner.coords
    
    [ [ 3,  4,  5],
      [-3, -4, -5],
      [ 2, -5,  8]
    ].each { |rel_coords| scanner.add_beacon *rel_coords }
    
    scanner.coords = [20, -25, 23]
    assert_equal Coords.new(20, -25, 23), scanner.coords
    
    expected = [
      [23, -21, 28],
      [17, -29, 18],
      [22, -30, 31]
    ]
    
    assert_equal expected, scanner.absolute_beacons
  end
  
  def test_orientation
    scanner = Scanner.new coords: [10, -20, 30], range: 50
    
    [ [-50, -10, -50],
      [ 50,  50,  50],
      [-20,  20,  30]
    ].each { |ary| scanner.add_beacon *ary }
    
    scanner.orientation = Orientation.new "-1+2-0"
    assert_equal [10, -20, 30], scanner.coords
    
    expected = [
      [ 10, -50,  50],
      [-50,  50, -50],
      [-20,  30,  20]
    ]
    
    assert_equal expected, scanner.beacons
  end
  
  def test_beacon_distances
    scanner = Scanner.new coords: [500, -500, 1000], range: 500
    
    [ [-500, -500, 250],
      [-200, -100, 250]
    ].each { |coords| scanner.add_beacon *coords }
    
    expected = [
      [  0.0, 500.0],
      [500.0,   0.0]
    ]
    
    assert_equal expected, scanner.beacon_distances
  end
  
  def test_beacons_detected_by
    scanner_a = Scanner.new coords: [0, 0, 0], range: 1000
    
    [ [ 0, -250, 750],
      [-1, -250, 750]
    ].each { |coords| scanner_a.add_beacon *coords }
    
    scanner_b = Scanner.new coords: [500, -500, 1000], range:  500
    
    [ [-250, 0,   0],
      [-250, 0, 500]
    ].each { |coords| scanner_b.add_beacon *coords }
    
    assert_equal 1, scanner_a.beacons_detected_by(scanner_b).size
    assert_equal 1, scanner_b.beacons_detected_by(scanner_a).size
  end
  
  def test_beacons_in_all_orientations
    scanner = Scanner.new coords: [0, 0, 0], range: 100

    [ [-1,-1, 1],
      [-2,-2, 2],
      [-3,-3, 3],
      [-2,-3, 1],
      [ 5, 6,-4],
      [ 8, 0, 7]
    ].each { |ary| scanner.add_beacon *ary }
    
    beacons_in_all_orientations = scanner.beacons_in_all_orientations
    
    [ [ [ 1,-1, 1],
        [ 2,-2, 2],
        [ 3,-3, 3],
        [ 2,-1, 3],
        [-5, 4,-6],
        [-8,-7, 0]
      ],
      [ [-1,-1,-1],
        [-2,-2,-2],
        [-3,-3,-3],
        [-1,-3,-2],
        [ 4, 6, 5],
        [-7, 0, 8]
      ],
      [ [ 1, 1,-1],
        [ 2, 2,-2],
        [ 3, 3,-3],
        [ 1, 3,-2],
        [-4,-6, 5],
        [ 7, 0, 8]
      ],
      [ [ 1, 1, 1],
        [ 2, 2, 2],
        [ 3, 3, 3],
        [ 3, 1, 2],
        [-6,-4,-5],
        [ 0, 7,-8]
      ]
    ].each { |beacons| assert_includes beacons_in_all_orientations, beacons }
  end
  
  def test_align_with_scanner
    scanner_a = Scanner.new
    scanner_b = Scanner.new
    scanner_c = Scanner.new
    
    [ [ 404, -588, -901],
      [ 528, -643,  409],
      [-838,  591,  734],
      [ 390, -675, -793],
      [-537, -823, -458],
      [-485, -357,  347],
      [-345, -311,  381],
      [-661, -816, -575],
      [-876,  649,  763],
      [-618, -824, -621],
      [ 553,  345, -567],
      [ 474,  580,  667],
      [-447, -329,  318],
      [-584,  868, -557],
      [ 544, -627, -890],
      [ 564,  392, -477],
      [ 455,  729,  728],
      [-892,  524,  684],
      [-689,  845, -530],
      [ 423, -701,  434],
      [   7,  -33,  -71],
      [ 630,  319, -379],
      [ 443,  580,  662],
      [-789,  900, -551],
      [ 459, -707,  401]
    ].each { |ary| scanner_a.add_beacon *ary }
    
    [
      [ 686,  422,  578],
      [ 605,  423,  415],
      [ 515,  917, -361],
      [-336,  658,  858],
      [  95,  138,   22],
      [-476,  619,  847],
      [-340, -569, -846],
      [ 567, -361,  727],
      [-460,  603, -452],
      [ 669, -402,  600],
      [ 729,  430,  532],
      [-500, -761,  534],
      [-322,  571,  750],
      [-466, -666, -811],
      [-429, -592,  574],
      [-355,  545, -477],
      [ 703, -491, -529],
      [-328, -685,  520],
      [ 413,  935, -424],
      [-391,  539, -444],
      [ 586, -435,  557],
      [-364, -763, -893],
      [ 807, -499, -711],
      [ 755, -354, -619],
      [ 553,  889, -390]
    ].each { |ary| scanner_b.add_beacon *ary }
    
    [ [ 727,  592,  562],
      [-293, -554,  779],
      [ 441,  611, -461],
      [-714,  465, -776],
      [-743,  427, -804],
      [-660, -479, -426],
      [ 832, -632,  460],
      [ 927, -485, -438],
      [ 408,  393, -506],
      [ 466,  436, -512],
      [ 110,   16,  151],
      [-258, -428,  682],
      [-393,  719,  612],
      [-211, -452,  876],
      [ 808, -476, -593],
      [-575,  615,  604],
      [-485,  667,  467],
      [-680,  325, -822],
      [-627, -443, -432],
      [ 872, -547, -609],
      [ 833,  512,  582],
      [ 807,  604,  487],
      [ 839, -516,  451],
      [ 891, -625,  532],
      [-652, -548, -490],
      [  30,  -46,  -14]
    ].each { |ary| scanner_c.add_beacon *ary }
    
    refute scanner_a.aligned_with?(scanner_b)
    refute scanner_b.aligned_with?(scanner_a)
    
    scanner_b.align_with scanner_a
    
    assert scanner_a.aligned_with?(scanner_b)
    assert scanner_b.aligned_with?(scanner_a)
    assert_equal [68, -1246, -43], scanner_b.coords
    
    refute scanner_b.aligned_with?(scanner_c)
    refute scanner_c.aligned_with?(scanner_b)

    scanner_c.align_with scanner_b
    
    assert scanner_b.aligned_with?(scanner_c)
    assert scanner_c.aligned_with?(scanner_b)
    assert_equal [-20, -1133, 1061], scanner_c.coords
  end
end

class RegionMapTest < Minitest::Test
  def test_orientations
    input = %Q(
      --- scanner 0 ---
      -1,-1,1
      -2,-2,2
      -3,-3,3
      -2,-3,1
      5,6,-4
      8,0,7
    )
    
    region_map  = RegionMap.parse input
    scanner     = region_map.scanners.first
    beacons_in_all_orientations = scanner.beacons_in_all_orientations
    
    [ [ [ 1,-1, 1],
        [ 2,-2, 2],
        [ 3,-3, 3],
        [ 2,-1, 3],
        [-5, 4,-6],
        [-8,-7, 0]
      ],
      [ [-1,-1,-1],
        [-2,-2,-2],
        [-3,-3,-3],
        [-1,-3,-2],
        [ 4, 6, 5],
        [-7, 0, 8]
      ],
      [ [ 1, 1,-1],
        [ 2, 2,-2],
        [ 3, 3,-3],
        [ 1, 3,-2],
        [-4,-6, 5],
        [ 7, 0, 8]
      ],
      [ [ 1, 1, 1],
        [ 2, 2, 2],
        [ 3, 3, 3],
        [ 3, 1, 2],
        [-6,-4,-5],
        [ 0, 7,-8]
      ]
    ].each { |coords| assert_includes beacons_in_all_orientations, coords }
  end
  
  def test_detection_regions
    input = %Q(
      --- scanner 0 ---
      404,-588,-901
      528,-643,409
      -838,591,734
      390,-675,-793
      -537,-823,-458
      -485,-357,347
      -345,-311,381
      -661,-816,-575
      -876,649,763
      -618,-824,-621
      553,345,-567
      474,580,667
      -447,-329,318
      -584,868,-557
      544,-627,-890
      564,392,-477
      455,729,728
      -892,524,684
      -689,845,-530
      423,-701,434
      7,-33,-71
      630,319,-379
      443,580,662
      -789,900,-551
      459,-707,401

      --- scanner 1 ---
      686,422,578
      605,423,415
      515,917,-361
      -336,658,858
      95,138,22
      -476,619,847
      -340,-569,-846
      567,-361,727
      -460,603,-452
      669,-402,600
      729,430,532
      -500,-761,534
      -322,571,750
      -466,-666,-811
      -429,-592,574
      -355,545,-477
      703,-491,-529
      -328,-685,520
      413,935,-424
      -391,539,-444
      586,-435,557
      -364,-763,-893
      807,-499,-711
      755,-354,-619
      553,889,-390

      --- scanner 2 ---
      649,640,665
      682,-795,504
      -784,533,-524
      -644,584,-595
      -588,-843,648
      -30,6,44
      -674,560,763
      500,723,-460
      609,671,-379
      -555,-800,653
      -675,-892,-343
      697,-426,-610
      578,704,681
      493,664,-388
      -671,-858,530
      -667,343,800
      571,-461,-707
      -138,-166,112
      -889,563,-600
      646,-828,498
      640,759,510
      -630,509,768
      -681,-892,-333
      673,-379,-804
      -742,-814,-386
      577,-820,562

      --- scanner 3 ---
      -589,542,597
      605,-692,669
      -500,565,-823
      -660,373,557
      -458,-679,-417
      -488,449,543
      -626,468,-788
      338,-750,-386
      528,-832,-391
      562,-778,733
      -938,-730,414
      543,643,-506
      -524,371,-870
      407,773,750
      -104,29,83
      378,-903,-323
      -778,-728,485
      426,699,580
      -438,-605,-362
      -469,-447,-387
      509,732,623
      647,635,-688
      -868,-804,481
      614,-800,639
      595,780,-596

      --- scanner 4 ---
      727,592,562
      -293,-554,779
      441,611,-461
      -714,465,-776
      -743,427,-804
      -660,-479,-426
      832,-632,460
      927,-485,-438
      408,393,-506
      466,436,-512
      110,16,151
      -258,-428,682
      -393,719,612
      -211,-452,876
      808,-476,-593
      -575,615,604
      -485,667,467
      -680,325,-822
      -627,-443,-432
      872,-547,-609
      833,512,582
      807,604,487
      839,-516,451
      891,-625,532
      -652,-548,-490
      30,-46,-14
    )
    
    region_map = RegionMap.parse input
    scanners   = region_map.scanners
    
    assert_equal 5, region_map.aligned_scanners.size
    
    expected = [
      [   0,     0,    0],
      [  68, -1246,  -43],
      [1105, -1205, 1229],
      [ -92, -2380,  -20],
      [ -20, -1133, 1061]
    ]
    
    assert_equal expected, scanners.map(&:coords)
    
    expected_coords = [
      [-618,-824,-621],
      [-537,-823,-458],
      [-447,-329, 318],
      [ 404,-588,-901],
      [ 544,-627,-890],
      [ 528,-643, 409],
      [-661,-816,-575],
      [ 390,-675,-793],
      [ 423,-701, 434],
      [-345,-311, 381],
      [ 459,-707, 401],
      [-485,-357, 347]
    ]
    
    beacon_coords = scanners[0].beacons_detected_by scanners[1]
    assert_equal expected_coords.sort, beacon_coords.sort
    
    beacon_coords = scanners[1].beacons_detected_by scanners[0]
    assert_equal expected_coords.sort, beacon_coords.sort

    expected_coords = [
      [ 459, -707,401],
      [-739,-1745,668],
      [-485, -357,347],
      [ 432,-2009,850],
      [ 528, -643,409],
      [ 423, -701,434],
      [-345, -311,381],
      [ 408,-1815,803],
      [ 534,-1912,768],
      [-687,-1600,576],
      [-447, -329,318],
      [-635,-1737,486]
    ]
    
    beacon_coords = scanners[1].beacons_detected_by scanners[4]
    assert_equal expected_coords.sort, beacon_coords.sort

    beacon_coords = scanners[4].beacons_detected_by scanners[1]
    assert_equal expected_coords.sort, beacon_coords.sort

    expected = [
      [-892,  524, 684],
			[-876,  649, 763],
			[-838,  591, 734],
			[-789,  900,-551],
			[-739,-1745, 668],
			[-706,-3180,-659],
			[-697,-3072,-689],
			[-689,  845,-530],
			[-687,-1600, 576],
			[-661, -816,-575],
			[-654,-3158,-753],
			[-635,-1737, 486],
			[-631, -672,1502],
			[-624,-1620,1868],
			[-620,-3212, 371],
			[-618, -824,-621],
			[-612,-1695,1788],
			[-601,-1648,-643],
			[-584,  868,-557],
			[-537, -823,-458],
			[-532,-1715,1894],
			[-518,-1681,-600],
			[-499,-1607,-770],
			[-485, -357, 347],
			[-470,-3283, 303],
			[-456, -621,1527],
			[-447, -329, 318],
			[-430,-3130, 366],
			[-413, -627,1469],
			[-345, -311, 381],
			[ -36,-1284,1171],
			[ -27,-1108, -65],
			[   7,  -33, -71],
			[  12,-2351,-103],
			[  26,-1119,1091],
			[ 346,-2985, 342],
			[ 366,-3059, 397],
			[ 377,-2827, 367],
			[ 390, -675,-793],
			[ 396,-1931,-563],
			[ 404, -588,-901],
			[ 408,-1815, 803],
			[ 423, -701, 434],
			[ 432,-2009, 850],
			[ 443,  580, 662],
			[ 455,  729, 728],
			[ 456, -540,1869],
			[ 459, -707, 401],
			[ 465, -695,1988],
			[ 474,  580, 667],
			[ 496,-1584,1900],
			[ 497,-1838,-617],
			[ 527, -524,1933],
			[ 528, -643, 409],
			[ 534,-1912, 768],
			[ 544, -627,-890],
			[ 553,  345,-567],
			[ 564,  392,-477],
			[ 568,-2007,-577],
			[ 605,-1665,1952],
			[ 612,-1593,1893],
			[ 630,  319,-379],
			[ 686,-3108,-505],
			[ 776,-3184,-501],
			[ 846,-3110,-434],
			[1135,-1161,1235],
			[1243,-1093,1063],
			[1660, -552, 429],
			[1693, -557, 386],
			[1735, -437,1738],
			[1749,-1800,1813],
			[1772, -405,1572],
			[1776, -675, 371],
			[1779, -442,1789],
			[1780,-1548, 337],
			[1786,-1538, 337],
			[1847,-1591, 415],
			[1889,-1729,1762],
			[1994,-1805,1792]
		]
		
		assert_equal expected.sort, region_map.beacons.sort
		assert_equal 79, region_map.beacon_count
  end
end
