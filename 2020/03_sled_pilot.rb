# frozen_string_literal: true

class ForestMap
  Position = Struct.new(:x, :y)
  def initialize(input)
    @input = input.map(&:chomp)
    @width = @input.first.length
    @height = @input.count
  end

  def to_s
    "<ForestMap #{@width},#{@height}>"
  end

  def slide(right, down)
    Enumerator.new do |enum|
      position = Position.new(0, 0)
      while position.y < @height - 1 do
        position.x += right
        position.y += down
        enum.yield tile(position)
      end
    end
  end

  def tile(position)
    @input[position.y][position.x % @width]
  end
end

class SledPilot
  def initialize(input)
    @input = input
    @map = ForestMap.new(input)
  end

  def part_one
    @map.slide(3, 1).count{|char| char == '#'}
  end
end

if __FILE__ == $0
  filename = "03_input.txt"
  input = File.readlines(filename)
  pilot = SledPilot.new(input)
  puts pilot.part_one
end
