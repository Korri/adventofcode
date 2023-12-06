# frozen_string_literal: true

class Race
  attr_reader :time, :record
  def initialize(time, record)
    @time = time
    @record = record
  end

  def distance_for_press_time(press_time)
    (time - press_time) * press_time
  end

  def possible_press_times
    (0..time).select do |press_time|
      distance_for_press_time(press_time) > record
    end
  end
end
if __FILE__ == $0
  filename = "06_input.txt"
  lines = File.readlines(filename, chomp: true)

  times = lines[0].split(/ +/)[1..].map(&:to_i)
  records = lines[1].split(/ +/)[1..].map(&:to_i)

  races = times.each_with_index.map do |time, index|
    Race.new(time, records[index])
  end

  p races.map(&:possible_press_times).map(&:size).reduce(1){|power, n| power * n}

  actual_race = Race.new(times.join("").to_i, records.join("").to_i)

  p actual_race
  p actual_race.possible_press_times.size
end
