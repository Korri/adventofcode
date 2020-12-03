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
    count_trees(3, 1)
  end

  def part_two
    count_trees(1, 1) * count_trees(3, 1) * count_trees(5, 1) * count_trees(7, 1) * count_trees(1, 2)
  end

  def count_trees(right, down)
    @map.slide(right, down).count { |char| char == '#' }
  end

end

if __FILE__ == $0
  filename = "03_input.txt"
  input = File.readlines(filename)
  pilot = SledPilot.new(input)
  puts pilot.part_one
  puts pilot.part_two
end
