# frozen_string_literal: true
class Digit
  def initialize(letters)
    @letters = letters.split("").sort
  end

  def guess
    case @letters.count
    when 2; 1
    when 3; 7
    when 4; 4
    when 7; 8
    else; nil
  end
  end
end

class Line
  def initialize(line)
    @line = line
    left, right = line.split(" | ")
    @alphabet = left.split(" ").map { |d| Digit.new(d) }
    @display = right.split(" ").map { |d| Digit.new(d) }
  end

  def count_simple_digits
    # puts "#{@line} => #{@display.count(&:guess)}" 
    @display.count(&:guess)
  end
end

if __FILE__ == $0
  filename = "08_input.txt"
  lines = File.readlines(filename).map{ |l| Line.new(l.strip) }
  puts lines.map(&:count_simple_digits).sum
end
