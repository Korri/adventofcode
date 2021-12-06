# frozen_string_literal: true
class Point
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    return "#{@x},#{@y}"
  end
end

class Line
  def initialize(start_point, end_point)
    @start = start_point
    @end = end_point
    # puts "#{@start.to_s} -> #{@end.to_s} => #{points.map(&:to_s).inspect}"
  end

  def straight?
    @start.x == @end.x || @start.y == @end.y
  end

  def points

    if @start.x == @end.x
      range(@start.y, @end.y).map { |y| Point.new(@start.x, y)}
    elsif @start.y == @end.y
      range(@start.x,@end.x).map { |x| Point.new(x, @start.y)}
    else
      range(@start.x,@end.x).zip(range(@start.y, @end.y)).map{|x, y| Point.new(x, y)}
    end
  end

  private

  def range(a, b)
    range = ([a,b].min..[a,b].max)
    return range.reverse_each if a > b
    range
  end
end

class Map
  def initialize(lines)
    @lines = lines.map do |text|
      points = text.split(" -> ").map{|point| point.split(',').map(&:to_i)}.map{|x, y| Point.new(x, y)}
      Line.new(*points)
    end
  end

  def overlap_count_straight
    map = {}
    @lines.filter(&:straight?).map(&:points).flatten.map(&:to_s).tally.count{|p, count| count > 1}
  end

  def overlap_count
    map = {}
    @lines.map(&:points).flatten.map(&:to_s).tally.count{|p, count| count > 1}
  end
end

if __FILE__ == $0
  filename = "05_input.txt"
  input = File.readlines(filename).map(&:strip)

  map = Map.new(input)
  puts map.overlap_count_straight
  puts map.overlap_count
end
