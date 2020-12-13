# frozen_string_literal: true

class Ferry
  CARDINALS = {
    'N' => [0, -1],
    'S' => [0, 1],
    'E' => [1, 0],
    'W' => [-1, 0],
  }

  def initialize()
    @pos = [0,0]
    @angle = 0
  end

  def direction
    [Math.cos(@angle * Math::PI / 180).to_i, Math.sin(@angle * Math::PI / 180).to_i]
  end

  def move(instruction)
    operation, distance = instruction.split(//, 2)
    distance = distance.to_i
    if CARDINALS.keys.include?(operation)
      move_in_direction(CARDINALS[operation], distance)
    elsif operation == 'F'
      move_in_direction(direction, distance)
    elsif operation == 'R'
      @angle += distance
    elsif operation == 'L'
      @angle -= distance
    else
      raise "Unknown operation #{operation}"
    end
    p [operation, distance, @pos, @angle]
  end

  def part_one(instruction)
    instruction.each{|line| move(line)}
  end

  def to_s
    "<Ferry #{@pos.inspect} => #{@pos.sum}>"
  end

  private

  def move_in_direction(direction, count)
    @pos = [@pos[0] + direction[0] * count, @pos[1] + direction[1] * count]
  end
end
if __FILE__ == $0
  filename = "12_input.txt"
  input = File.read(filename)

  ferry = Ferry.new
  ferry.part_one(input.split("\n"))
  puts ferry
end
