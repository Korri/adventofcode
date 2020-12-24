class TileMap
  def turn_tiles(instructions)
    tiles = {}
    instructions.each do |instructions|
      pos = walk(instructions)
      if tiles[pos].nil?
        tiles[pos] = true
      else
        tiles.delete(pos)
      end
      tiles
    end

    tiles
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

  def art(old_black)
    100.times do
      touches_black = {}
      old_black.each do |tile|
        x, y = tile
        [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1], [x - 1, y -1], [x + 1, y + 1]].each do |next_to|
          touches_black[next_to] ||= 0
          touches_black[next_to] += 1
        end
      end
      new_black = []
      touches_black.each do |tile, count|
        new_black << tile if count == 2 && !old_black.include?(tile)
      end
      old_black.each do |tile|
        new_black << tile unless touches_black[tile].nil? || touches_black[tile] > 2
      end

      puts new_black.count
      old_black = new_black
    end
  end
end

if __FILE__ == $0
  input = File.read('24_input.txt')
  map = TileMap.new
  tiles = map.turn_tiles(input.split("\n"))
  p tiles.values.count
  map.art(tiles.keys)
end

# 1 2 3 4
#  5 6 7
# 8 9 0
