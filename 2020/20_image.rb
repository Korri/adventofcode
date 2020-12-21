class Tile
  attr_reader :id

  def initialize(string)
    id_string, data_string = string.split("\n", 2)
    @data = data_string.split("\n").map { |line| line.split(//) }
    @id = id_string[5..-1].to_i
  end

  def rotate
    @data = @data.transpose.map(&:reverse)
  end

  def flip
    @data = @data.map(&:reverse)
  end

  def borders
    [
      @data.first,
      @data.map(&:last),
      @data.last.reverse,
      @data.map(&:first).reverse,
    ]
  end

  def matches?(other, direction, can_rotate)
    border = direction == 'top' ? other.borders[2] : other.borders[1]
    border.reverse!
    border_index = direction == 'top' ? 0 : 3

    return true if borders[border_index] == border
    return false unless can_rotate
    iterate_variations do
      return true if borders[border_index] == border
    end
    false
  end

  def iterate_variations
    yield self
    (0..3).each do
      self.rotate
      yield self
    end
    self.flip
    (0..4).each do
      yield self
      self.rotate
    end
  end

  def to_s
    "Tile #{@id}\n#{@data.map { |line| line.join('') }.join("\n")}"
  end
end

class Image
  def initialize(tiles)
    @tiles = tiles.map { |data| Tile.new data }
  end

  def find_layout
    @map = []
    (0..).each do |row|
      (0..).each do |col|
        found_tile = find_tile(row, col)
        break unless found_tile
        @map[row] ||= []
        @map[row][col] = found_tile
        @tiles -= [found_tile]
      end
      break if @tiles.empty?
    end
  end

  def find_tile(row, col)
    return find_corner if [row, col] == [0, 0]

    top_tile = nil
    left_tile = nil
    top_tile = @map[row - 1][col] unless row == 0
    left_tile = @map[row][col - 1] unless col == 0
    @tiles.find do |tile|
      unless top_tile.nil?
        next false unless tile.matches?(top_tile, "top", true)
      end
      unless left_tile.nil?
        next false unless tile.matches?(left_tile, "left", top_tile.nil?)
      end
      true
    end
  end

  def find_corner
    all_borders = @tiles.map(&:borders).flatten(1)
    all_borders += all_borders.map(&:reverse)
    borders_count = all_borders.inject(Hash.new(0)) { |total, e| total[e] += 1; total }
    @tiles.find do |tile|
      next false unless tile.borders.count { |border| borders_count[border] > 1 } == 2
      tile.iterate_variations do
        break if borders_count[tile.borders[0]] == 1 && borders_count[tile.borders[3]] == 1
      end
      true
    end
  end

  def corners
    [
      @map.first.first,
      @map.first.last,
      @map.last.first,
      @map.last.last,
    ]
  end

  def to_s
    @map.map { |row| row.map(&:id).join('    ') }.join("\n")
  end
end

if __FILE__ == $0
  input = File.read('20_input.txt')
  tiles = input.split("\n\n")

  image = Image.new(tiles)
  image.find_layout
  puts image
  p image.corners.map(&:id).reduce(1, &:*)
end
