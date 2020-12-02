# frozen_string_literal: true

class PasswordChecker
  def initialize(input)
    @input = input
  end

  def count
    @input.select do |line|
      values = line.match(/^(\d+)-(\d+) ([a-z]): (.+)$/)
      puts line unless values
      next unless values
      is_valid = valid values[1].to_i, values[2].to_i, values[3], values[4]
      # puts line unless is_valid

      is_valid
    end.count
  end

  def valid(min, max, letter, password)
    count = password.count(letter)
    min <= count && count <= max
  end
end

if __FILE__ == $0
  filename = "02_input.txt"
  input = File.readlines(filename)
  counter = PasswordChecker.new(input)
  puts counter.count
end
