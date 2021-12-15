# frozen_string_literal: true

require 'enumerator'

class Octopus
    attr_accessor :energy
  def initialize(energy, position, map)
    @energy = energy
    @position = position
    @map = map
    @popped = false
  end

  def x
    @position % @map.width
  end

  def y
    @position / @map.width
  end

  def to_s
    "#{@position} (#{x},#{y})"
  end

  def neightboors
    (x - 1..x + 1).flat_map do |xpos|
      (y - 1..y + 1).map do |ypos|
        next if xpos < 0 || xpos >= @map.width || ypos < 0 || ypos >= @map.height
        next if xpos == x && ypos == y

        @map.get(xpos, ypos)
      end
    end.compact
  end
  
  def charge
    @energy += 1
  end

  def pop
    return if @popped || @energy <= 9
    neightboors.map(&:charge)
    @popped = true
  end

  def reset
    return false if @energy <= 9
    @energy = 0
    @popped = false
    true
  end
end

class Map
  attr_accessor :width, :height, :flashes

  def initialize(lines)
    lines = lines.map { |line| line.split("").map(&:to_i) }
    @width = lines.first.count
    @height = lines.count
    @octopuses = lines.flatten.each_with_index.map { |energy, position| Octopus.new(energy, position, self) }
    @flashes = 0
  end

  def get(x, y)
    @octopuses[x + y * @width]
  end

  def tick
    # puts "Map: \n#{to_s}"
    @octopuses.each do |octopus|
      octopus.charge
    end

    while @octopuses.any?(&:pop); end

    flashes = @octopuses.count{ |octopus| octopus.reset }
    @flashes += flashes
  end

  def to_s
    @octopuses.map(&:energy).each_slice(@width).map(&:join).join("\n")
  end
end

if __FILE__ == $0
  filename = "11_input.txt"
  input = File.readlines(filename).map(&:strip)

  map = Map.new(input)
  # puts map.low_points_altitude.inspect
  100.times do
    map.tick
  end

  puts map.flashes
end
