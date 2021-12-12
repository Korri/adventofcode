# frozen_string_literal: true
class Digit
  attr_accessor :letters

  def initialize(letters)
    @letters = letters.split("").sort.join("")
  end

  def simple_digit
    case @letters.length
      when 2; 1
      when 3; 7
      when 4; 4
      when 7; 8
      else; nil
    end
  end

  def possibilities
    case @letters.length
      when 2; 1
      when 3; 7
      when 4; 4
      # when 5; [2, 3, 5]
      # when 6; [6, 9, 0]
      when 7; 8
      else; nil
    end
  end

  def deduce(known_guesses)
    case @letters.length
      when 2; 1
      when 3; 7
      when 4; 4
      when 5
        one = known_guesses[1]
        if common(one) == 2
          3
        else
          four = known_guesses[4]
          common(four) == 2 ? 2 : 5
        end
      when 6
        one = known_guesses[1]
        if common(one) == 1
          6
        else
          four = known_guesses[4]
          common(four) == 4 ? 9 : 0
        end
      when 7; 8
      else; nil
    end
  end

  def common(other)
    (other.split("") & @letters.split("")).count
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
    @display.count(&:simple_digit)
  end

  def deduce
    zip = @alphabet.map { |digit| [digit.possibilities, digit.letters] }
    known_guesses = Hash[zip]
    dic = Hash[@alphabet.map { |digit| [digit.letters, digit.deduce(known_guesses)] }]
    @display.map { |digit| dic[digit.letters] }.join("").to_i
  end
end

if __FILE__ == $0
  filename = "08_input.txt"
  lines = File.readlines(filename).map{ |l| Line.new(l.strip) }
  puts lines.map(&:count_simple_digits).sum
  puts lines.map(&:deduce).sum
end
