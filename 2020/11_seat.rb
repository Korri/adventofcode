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
      # puts "#{index}, #{visible(index).inspect}" if index == 9
      if tile == 'L'
        next '#' unless visible(index).include?('#')
      elsif tile == '#'
        next 'L' if visible(index).count('#') >= 5
      end

      tile
    end
  end

  def tick_loop
    puts self
    puts

    new_map = tick
    if @data.to_s == new_map.to_s
      @data = new_map
      puts self
      return
    end

    @data = new_map
    tick_loop
  end

  def adjacent_indexes(index)
    x, y = index_to_pos(index)
    x_range = [0, x-1].max..[@width - 1, x+1].min
    y_range = [0, y-1].max..y+1

    x_range.map{|xval| y_range.map{|yval| pos_to_index(xval, yval) }}.flatten.compact - [index]
  end

  def adjacent(index)
    adjacent_indexes(index).map{|index| @data[index]}
  end

  def visible(index)
    position = index_to_pos(index)
    directions = [*-1..1, *-1..1].to_a.combination(2).to_a.uniq - [[0,0]]
    directions.map { |direction| next_in_direction(position, direction) }.compact
  end

  def next_in_direction(position, direction)
    loop do
      position = position.zip(direction).map(&:sum)
      index = pos_to_index(*position)
      return nil if index.nil?
      tile = @data[index]
      return tile unless tile == '.'
    end
  end

  def to_s
    @data.each_slice(@width).map(&:join).join("\n")
  end

  def tiles
    @data
  end

  private

  def pos_to_index(xval, yval)
    return nil if xval < 0
    return nil if yval < 0
    return nil if xval >= @width
    return nil if yval >= @data.count / @width

    yval * @width + xval
  end

  def index_to_pos(index)
    x = index % @width
    y = index / @width
    [x, y]
  end
end

if __FILE__ == $0
  filename = "11_input.txt"
  input = File.read(filename)

  map = Map.new(input.split("\n"))
  map.tick_loop
  puts map.tiles.count('#')
end
