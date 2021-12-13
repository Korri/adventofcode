# frozen_string_literal: true
class Bassin
  attr_accessor :x, :y

  def initialize(position, map)
    @position =
    @y = y
  end

  def to_s
    return "#{@x},#{@y}"
  end
end

class Map
  def initialize(lines)
    lines = lines.map { |line| line.split("").map(&:to_i) }
    @width = lines.first.count
    @height = lines.count
    @data = lines.flatten
  end

  def low_points
    @data.each_with_index.reject do |altitude, position|
      neightboors(position).any? { |neightboor| @data[neightboor] <= altitude }
    end
  end

  def low_points_altitude
    low_points.map { |altitude, _| altitude }
  end

  def low_points_positions
    low_points.map { |_, position| position }
  end

  def bassins
    low_points_positions.each_with_object([]) do |low_point, bassins|
      bassins << bassin_at(low_point)
    end
  end

  def bassin_at(low_point)
    bassin = [low_point]
    neightboors(low_point).each do |neightboor|
      if @data[neightboor] < 9 && @data[neightboor] > @data[low_point]
        bassin += bassin_at(neightboor)
      end
    end
    bassin.uniq
  end

  def neightboors(position)
    x = position % @width
    y = position / @width
    offsets = []
    offsets << position - 1 if x > 0
    offsets << position + 1 if x < @width - 1
    offsets << position - @width if y > 0
    offsets << position + @width if y < @height - 1

    offsets
  end
end

if __FILE__ == $0
  filename = "09_input.txt"
  input = File.readlines(filename).map(&:strip)

  map = Map.new(input)
  # puts map.low_points_altitude.inspect
  puts map.low_points_altitude.map { |a| a + 1 }.sum

  # puts map.bassins.inspect
  puts map.bassins.sort_by(&:count)[-3..-1].map(&:count).reduce(&:*)
end
