require 'minitest/autorun'

require_relative 'day_05.rb'

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
  ).strip.split("\n").map &:strip
 
  def test_check_for_vertical_or_horizontal_lines
    vents = INPUT.map { |entry| Vent.new entry }
    
    assert_equal 2, vents.count(&:vertical_line?)
    assert_equal 4, vents.count(&:horizontal_line?)
    assert_equal 4, vents.count(&:diagonal_line?)
  end
  
  def test_point_coverage
    vertical_vent   = Vent.new "7,0 -> 7,4"
    expected_points = [[7, 0], [7, 1], [7, 2], [7, 3], [7, 4]]
    assert_equal expected_points.sort, vertical_vent.points.sort
    
    horizontal_vent = Vent.new "9,4 -> 3,4"
    expected_points = [[9, 4], [8, 4], [7, 4], [6, 4], [5, 4], [4, 4], [3, 4]]
    assert_equal expected_points.sort, horizontal_vent.points.sort
    
    diagonal_vent   = Vent.new "9,7 -> 7,9"
    expected_points = [[9, 7], [8, 8], [7, 9]]
    assert_equal expected_points.sort, diagonal_vent.points.sort
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
  ).strip.split("\n").map &:strip

  def test_display_as_string
    vents = INPUT.map { |entry| Vent.new entry }
    vents.select! { |vent| vent.vertical_line? || vent.horizontal_line? }
    
    diagram = Diagram.new *vents
    
    expected_render = %Q(
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
    
    assert_equal expected_render, diagram.to_s    
  end
  
  def test_dangerous_areas
    vents = INPUT.map { |entry| Vent.new entry }
    vents.select! { |vent| vent.vertical_line? || vent.horizontal_line? }
    diagram = Diagram.new *vents
    
    assert_equal 5, diagram.dangerous_areas
    
    vents = INPUT.map { |entry| Vent.new entry }
    vents.select! { |vent| vent.vertical_line? || vent.horizontal_line? || vent.diagonal_line? }
    diagram = Diagram.new *vents
    
    assert_equal 12, diagram.dangerous_areas
    
  end
end
