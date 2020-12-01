# frozen_string_literal: true

class StarCounter
  def initialize(input)
    @input = input
  end

  def find_entries
    @input.combination(2).find {|a,b| a + b == 2020 }&.sort
  end

end

if __FILE__ == $0
  filename = "01_input.txt"
  input = File.readlines(filename).map(&:to_i)
  pair = StarCounter.new(input).find_entries
  puts pair
  puts pair&.reduce(1, :*)
end
