# frozen_string_literal: true
class Crab
  def initialize(position)
    @position = position
  end

  def fuel_to(position)
    distance = (@position - position).abs
    (distance / 2.0) * (distance + 1)
  end
end

class Swarm
  def initialize(positions)
    @positions = positions.sort
    @crabs = @positions.map { |position| Crab.new(position) }
  end
  def best_position
    (@positions.first..@positions.max).map do |target|
      @crabs.map { |crab| crab.fuel_to(target) }.sum
    end.min
  end
end

if __FILE__ == $0
  filename = "07_input.txt"
  input = File.readlines(filename).first.split(',').map(&:to_i)

  puts Swarm.new(input).best_position
end
