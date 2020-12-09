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

  def encryption_weakness
    number = first_invalid
    (2..@numbers.length).each do |range_length|
      range = @numbers.each_cons(range_length).find{|range| range.sum == number}
      return range.min + range.max if range
    end
    raise "Could not find a weakness"
  end
end

if __FILE__ == $0
  filename = "09_input.txt"
  input = File.read(filename)
  console = XmasValidator.new(input.split("\n"))
  puts console.encryption_weakness
end
