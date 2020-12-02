# frozen_string_literal: true

class PasswordChecker
  def initialize(input)
    @input = input
  end

  def count
    @input.select do |line|
      values = line.match(/^(\d+)-(\d+) ([a-z]): (.+)$/)
      next unless values
      valid values[1].to_i, values[2].to_i, values[3], values[4]
    end.count
  end

  def sled_rental_valid(min, max, letter, password)
    count = password.count(letter)
    min <= count && count <= max
  end

  def valid(min, max, letter, password)
    string = "#{password[min-1]}#{password[max-1]}"
    string.count(letter) == 1
  end
end

if __FILE__ == $0
  filename = "02_input.txt"
  input = File.readlines(filename)
  counter = PasswordChecker.new(input)
  puts counter.count
end
