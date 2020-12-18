# frozen_string_literal: true

class PocketDimension
  def initialize(first_layer)
    @first_layer = first_layer.split("\n").map { |line| line.split(//) }
  end

  def tick(times)
    initialize_map(times)
    times.times do
      new_map = @map.dup

      iterate do |pos|
        cube = @map[pos]
        active_count = neighbours(pos).count { |neighbour| @map[neighbour] == '#' }
        new_map[pos] = '#' if cube == '.' && active_count == 3
        new_map[pos] = '.' if cube == '#' && !active_count.between?(2, 3)
      end
      @map = new_map
      puts count_active
    end
  end

  def count_active
    count = 0
    iterate do |pos|
      count += 1 if @map[pos] == '#'
    end
    count
  end

  private

  def iterate
    @height.times do |w|
      @height.times do |z|
        @depth.times do |y|
          @width.times do |x|
            yield [x, y, z, w]
          end
        end
      end
    end
  end

  def neighbours(pos)
    values = pos.map { |value| (value - 1..value + 1).to_a }
    values[0].product(values[1], values[2], values[3]) - [pos]
  end

  def initialize_map(times)
    @map = {}
    @width = @first_layer[0].count + times * 2
    @depth = @first_layer.count + times * 2
    @height = 1 + times * 2

    iterate do |pos|
      @map[pos] = '.'
      if pos[2] === times && pos[3] === times && pos[0] >= times && pos[1] >= times
        first_layer_x = pos[0] - times
        first_layer_y = pos[1] - times
        row = @first_layer[first_layer_y]
        @map[pos] = row[first_layer_x] || '.' unless row.nil?
      end
    end
  end
end

if __FILE__ == $0
  filename = "17_input.txt"
  input = File.read(filename)

  map = PocketDimension.new(input)
  map.tick(6)
end
