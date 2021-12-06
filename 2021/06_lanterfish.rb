# frozen_string_literal: true
class School
  def initialize(list)
    @lanternfishes = list.tally
  end

  def after(times)
    times.times do |day|
      tick
    end
    @lanternfishes.values.sum
  end

  def tick
    hashes = @lanternfishes.map do |number, count|
      number -= 1
      if number < 0
        {6 => count, 8 => count}
      else
        {number => count}
      end
    end
    @lanternfishes = hashes.reduce({}) do |res, hash|
      res.merge(hash) {|key, a, b| a + b}
    end
  end
end

if __FILE__ == $0
  filename = "06_input.txt"
  input = File.readlines(filename).first.split(',').map(&:to_i)

  puts School.new(input).after(80)
  puts School.new(input).after(256)
end
