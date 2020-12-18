# frozen_string_literal: true

class PocketDimension
  def initialize(first_layer)
    @first_layer = first_layer.split("\n").map { |line| line.split(//) }
  end

  def tick(times)
    initialize_map(times)
    # puts "Before any cycles:"
    # puts self
    times.times do |cycle|
      new_map = @map.dup

      iterate do |pos|
        cube = @map[pos]
        active_neighbours = neighbours(pos).select {|neighbour| @map[neighbour] == '#'}
        if active_neighbours.count > 1
          #puts "#{pos.inspect} has active neighbours: #{active_neighbours.inspect}"
        end
        active_count = neighbours(pos).count {|neighbour| @map[neighbour] == '#'}
        new_map[pos] = '#' if cube == '.' && active_count == 3
        new_map[pos] = '.' if cube == '#' && !active_count.between?(2,3)
      end
      @map = new_map
      # puts "After #{cycle+1} cycles:"
      # puts self
    end
  end

  def count_active
    count = 0
    iterate do |pos|
      count += 1 if @map[pos] == '#'
    end
    count
  end

  def to_s
    z = nil
    y = nil
    result = ''
    iterate do |pos|
      if z != pos[2]
        result += "\n\nz=#{pos[2].to_s}"
        z = pos[2]
      end
      if y != pos[1]
        result += "\n"
        y = pos[1]
      end
      result += @map[pos]
    end
    result
  end

  private

  def iterate
    @height.times do |z|
      @depth.times do |y|
        @width.times do |x|
          yield [x, y, z]
        end
      end
    end
  end

  def neighbours(pos)
    values = pos.map{|value| (value-1..value+1).to_a}
    values[0].product(values[1], values[2]) - [pos]
  end

  def initialize_map(times)
    @map = {}
    @width = @first_layer[0].count + times * 2
    @depth = @first_layer.count + times * 2
    @height = 1 + times * 2
    iterate do |pos|
      @map[pos] = '.'
      if pos[2] === times && pos[0] >= times && pos[1] >= times
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
  puts map.count_active
end
