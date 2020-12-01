# frozen_string_literal: true

class StarCounter
  def initialize(input)
    @input = input
  end

  def find_entries(count = 2)
    @input.combination(count).find {|arg| arg.reduce(0, &:+) == 2020 }&.sort
  end

end

if __FILE__ == $0
  filename = "01_input.txt"
  input = File.readlines(filename).map(&:to_i)
  counter = StarCounter.new(input)
  pair = counter.find_entries
  puts pair
  puts pair&.reduce(1, :*)

  trio = counter.find_entries(3)
  puts trio
  puts trio&.reduce(1, :*)
end
