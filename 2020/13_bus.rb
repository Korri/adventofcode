# frozen_string_literal: true

class Bus
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def wait(time_of_day)
    id - time_of_day % @id
  end
end

def part_one(buses, time)
  buses = (buses.split(',') - ['x']).map(&:to_i).map{|id| Bus.new(id) }
  buses = buses.sort_by { |bus| bus.wait(time) }

  best_bus = buses.first
  p best_bus.wait(time) * best_bus.id
end

if __FILE__ == $0
  filename = "13_input.txt"
  input = File.read(filename)
  time, buses = input.split("\n")
  time = time.to_i

  part_one(buses, time)
end
