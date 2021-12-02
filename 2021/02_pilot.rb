# frozen_string_literal: true

class Pilot
  DIRECTIONS = {
    'forward' => [1, 0],
    'down' => [0, 1],
    'up' => [0, -1],
  }

  def initialize
    @x = 0
    @depth = 0
    @aim = 0
  end

  def navigate(moves)
    moves.each do |instruction|
      move(instruction)
    end
  end

  def move(instruction)
    direction, amount = instruction.split(' ')
    amount = amount.to_i
    forward_change, depth_change = DIRECTIONS[direction]

    @x += forward_change * amount
    @depth += forward_change * @aim * amount
    @aim += depth_change * amount
  end

  def print
    puts "Position: #{@x}, #{@depth}: #{@x * @depth}"
  end
end

if __FILE__ == $0
  filename = "02_input.txt"
  input = File.readlines(filename).map(&:strip)

  pilot = Pilot.new
  pilot.navigate(input)
  pilot.print
end
