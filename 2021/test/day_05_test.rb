require 'minitest/autorun'
require 'day_05'

class VentTest < Minitest::Test
  INPUT = %Q(
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  )
 
  def test_check_for_vertical_or_horizontal_lines
    vents = Vent.parse INPUT
    
    assert_equal 2, vents.count(&:vertical?)
    assert_equal 4, vents.count(&:horizontal?)
    assert_equal 4, vents.count(&:diagonal?)
  end
  
  def test_point_coverage
    vertical = Vent.new "7,0 -> 7,4"
    expected = [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4]]
    assert_equal expected.sort, vertical.points.sort
    
    horizontal = Vent.new "9,4 -> 3,4"
    expected   = [[9, 4], [8, 4], [7, 4], [6, 4], [5, 4], [4, 4], [3, 4]]
    assert_equal expected.sort, horizontal.points.sort
    
    diagonal   = Vent.new "9,7 -> 7,9"
    expected   = [[9, 7], [8, 8], [7, 9]]
    assert_equal expected.sort, diagonal.points.sort
  end
end

class DiagramTest < Minitest::Test
  INPUT = %Q(
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
  )

  def test_display_as_string
    vents   = Vent.parse(INPUT).select { |v| v.vertical? || v.horizontal? }
    diagram = Diagram.new *vents
    
    expected = %Q(
      .......1..
      ..1....1..
      ..1....1..
      .......1..
      .112111211
      ..........
      ..........
      ..........
      ..........
      222111....
    ).strip.gsub " ", ""
    
    assert_equal expected, diagram.to_s    
  end
  
  def test_dangerous_areas
    vents       = Vent.parse INPUT
    verticals   = vents.select &:vertical?
    horizontals = vents.select &:horizontal?
    diagonals   = vents.select &:diagonal?
    
    diagram = Diagram.new *(verticals + horizontals)
    assert_equal 5, diagram.dangerous_area_count
    
    diagram = Diagram.new *(verticals + horizontals + diagonals)
    assert_equal 12, diagram.dangerous_area_count
  end
end
