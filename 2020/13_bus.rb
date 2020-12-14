# frozen_string_literal: true

class Bus
  attr_reader :id
  attr_reader :index

  def initialize(id, index = nil)
    @id = id
    @index = index
  end

  def wait(time_of_day)
    (@id - time_of_day % @id) % @id
  end

  def test(time_of_day)
    (time_of_day + @index) % @id == 0
  end
end

def part_one(buses, time)
  buses = (buses.split(',') - ['x']).map(&:to_i).map { |id| Bus.new(id) }
  buses = buses.sort_by { |bus| bus.wait(time) }

  best_bus = buses.first
  p best_bus.wait(time) * best_bus.id
end

class Scheduler
  def initialize(buses_string)
    values = buses_string.split(',')
    @buses = []
    values.each_with_index do |id, index|
      next if id == 'x'
      @buses << Bus.new(id.to_i, index)
    end
    p @buses.map{|bus| [bus.id, bus.index]}
  end\

  def find_perfect_time
    first_bus = @buses.first
    timestamp = first_bus.id + first_bus.index
    increment = first_bus.id
    matched = 1
    loop do
      found = @buses.select { |bus| bus.test(timestamp) }
      return timestamp if found.length == @buses.length
      if found.length > matched
        matched = found.length
        increment = found.map(&:id).reduce(1, &:lcm)
      end
      timestamp += increment
    end
  end
end

if __FILE__ == $0
  filename = "13_input.txt"
  input = File.read(filename)
  time, buses = input.split("\n")
  time = time.to_i

  part_one(buses, time)

  scheduler = Scheduler.new(buses)
  p scheduler.find_perfect_time
end
