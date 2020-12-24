class TileMap
  def turn_tiles(instructions)
    tiles = {}
    instructions.each do |instructions|
      pos = walk(instructions)
      tiles[pos] = tiles[pos] ? false : true
    end

    p tiles.values.select{|tile| tile}.count
  end

  def walk(directions)
    directions = directions.scan(/e|ne|w|nw|se|sw/).to_a
    x = 0
    y = 0
    directions.each do |direction|
      case direction
        when 'e'
          x += 1
        when 'w'
          x -= 1
        when 'ne'
          y -= 1
        when 'se'
          y += 1
          x += 1
        when 'nw'
          y -= 1
          x -= 1
        when 'sw'
          y += 1
      end
    end

    [x, y]
  end
end

if __FILE__ == $0
  input = File.read('24_input.txt')
  map = TileMap.new
  map.turn_tiles(input.split("\n"))
end


# 1 2 3 4
#  5 6 7
# 8 9 0
