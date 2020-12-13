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
    @waypoint = Waypoint.new
  end

  def move(instruction)
    operation, distance = instruction.split(//, 2)
    distance = distance.to_i
    if CARDINALS.keys.include?(operation)
      @waypoint.move(CARDINALS[operation], distance)
    elsif operation == 'F'
      move_to_waypoint(distance)
    elsif operation == 'R'
      @waypoint.rotate(distance)
    elsif operation == 'L'
      @waypoint.rotate(-distance)
    else
      raise "Unknown operation #{operation}"
    end
    p [operation, distance, @pos, @angle, @waypoint.to_s]
  end

  def part_one(instruction)
    instruction.each{|line| move(line)}
  end

  def to_s
    "<Ferry #{@pos.inspect} => #{@pos.map(&:abs).sum}>"
  end

  private

  def move_to_waypoint(count)
    @pos = [@pos[0] + @waypoint.pos[0] * count, @pos[1] + @waypoint.pos[1] * count]
  end
end

class Waypoint
  attr_reader :pos

  def initialize
    @pos = [10, -1]
  end

  def rotate(angle)
    while angle > 0
      @pos = [-@pos[1], @pos[0]]
      angle -= 90
    end
    while angle < 0
      @pos = [@pos[1], -@pos[0]]
      angle += 90
    end
  end

  def move(direction, count)
    @pos = [@pos[0] + direction[0] * count, @pos[1] + direction[1] * count]
  end

  def to_s
    "<Waypoint #{@pos.inspect}>"
  end
end

if __FILE__ == $0
  filename = "12_input.txt"
  input = File.read(filename)

  ferry = Ferry.new
  ferry.part_one(input.split("\n"))
  puts ferry
end
