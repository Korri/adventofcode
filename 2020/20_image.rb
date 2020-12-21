class Shape
  def initialize(data)
    @data = data
  end

  def initialize_copy(other)
    super
    @data = @data.dup
  end

  def tile(x, y)
    @data[y][x]
  end

  def self.from_string(string)
    Shape.new(string.split("\n").map { |line| line.split(//) })
  end

  def rotate
    @data = @data.transpose.map(&:reverse)
  end

  def flip
    @data = @data.map(&:reverse)
  end

  def to_s
    @data.map { |line| line.join('') }.join("\n")
  end

  def width
    @data[0].count
  end

  def height
    @data.count
  end

  def each_variation
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

  def find_and_remove(shape)
    count = 0
    (0..width - shape.width).each do |x|
      (0..height - shape.height).each do |y|
        if shape_matches?(shape, x, y)
          delete_shape(shape, x, y)
          count += 1
        end
      end
    end
    count
  end

  def shape_matches?(shape, posx, posy)
    (0...shape.width).each do |x|
      (0...shape.height).each do |y|
        next unless shape.tile(x, y) == '#'
        return false unless @data[y + posy][x + posx] == '#'
      end
    end
  end

  def delete_shape(shape, posx, posy)
    (0...shape.width).each do |x|
      (0...shape.height).each do |y|
        @data[y + posy][x + posx] = 'O' if shape.tile(x, y) == '#'
      end
    end
  end
end

class Tile < Shape
  attr_reader :id
  attr_accessor :data

  def initialize(string = nil)
    id_string, data_string = string.split("\n", 2)
    data = data_string.split("\n").map { |line| line.split(//) }
    super(data)
    @id = id_string[5..-1].to_i
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
    each_variation do
      return true if borders[border_index] == border
    end
    false
  end

  def without_borders
    @data[1..-2].map { |line| line[1..-2] }
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
      tile.each_variation do
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
    # flatten.inspect
    flatten.map(&:join).join("\n")
  end

  def flatten
    @map
      .map do |row|
      row.map(&:without_borders)
         .transpose
         .map { |row| row.flatten(1) }
    end.flatten(1)
  end

  def find_monsters
    shape = Shape.new(flatten)
    finder = MonsterFinder.new(shape)
    finder.find
  end
end

class MonsterFinder
  MONSTER = <<MONSTER
                  # 
#    ##    ##    ###
 #  #  #  #  #  #
MONSTER

  def initialize(shape)
    @shape = shape
    @monster = Shape.from_string(MONSTER)
    puts "Monster:"
    puts @monster
  end

  def find
    puts "Finding in:\n#{@shape}"
    @shape.each_variation do
      shape = @shape.dup
      count = shape.find_and_remove(@monster)
      if count > 0
        puts "Found monsters:"
        puts shape
        puts shape.to_s.count('#')
      end
    end
  end
end

if __FILE__ == $0
  input = File.read('20_input.txt')
  tiles = input.split("\n\n")

  image = Image.new(tiles)
  image.find_layout
  puts image
  image.find_monsters
end
