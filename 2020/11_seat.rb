# frozen_string_literal: true

class Seat
  def initialize(pos, map)
    @map = map
    @pos = pos
  end
end

class Map
  def initialize(map)
    @width = map[0].length
    @data = map.join('').split(//)
  end

  def tick
    @data.each_with_index.map do |tile, index|
      if tile == 'L'
        next '#' unless adjacent(index).include?('#')
      elsif tile == '#'
        next 'L' if adjacent(index).count('#') >= 4
      end

      tile
    end
  end

  def loop
    puts self
    puts

    new_map = tick
    if @data.to_s == new_map.to_s
      @data = new_map
      puts self
      return
    end

    @data = new_map
    loop
  end

  def adjacent_indexes(index)
    x = index % @width
    y = index / @width
    x_range = [0, x-1].max..[@width - 1, x+1].min
    y_range = [0, y-1].max..y+1

    x_range.map{|xval| y_range.map{|yval| yval * @width + xval }}.flatten.compact - [index]
  end

  def adjacent(index)
    adjacent_indexes(index).map{|index| @data[index]}
  end

  def to_s
    @data.each_slice(@width).map(&:join).join("\n")
  end

  def tiles
    @data
  end
end

if __FILE__ == $0
  filename = "11_input.txt"
  input = File.read(filename)

  map = Map.new(input.split("\n"))
  map.loop
  puts map.tiles.count('#')
end
