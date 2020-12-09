# frozen_string_literal: true

class XmasValidator
  def initialize(numbers, preamble_length = 25)
    @numbers = numbers.map(&:to_i)
    @preamble_length = preamble_length
  end

  def valid(index)
    numbers = @numbers[index-@preamble_length...index]
    number = @numbers[index]

    numbers.combination(2).map(&:sum).include?(number)
  end

  def first_invalid
    invalid_index = (@preamble_length...@numbers.count).find{|index| !valid(index) }

    @numbers[invalid_index]
  end
end

if __FILE__ == $0
  filename = "09_input.txt"
  input = File.read(filename)
  console = XmasValidator.new(input.split("\n"))
  puts console.first_invalid
end
