# frozen_string_literal: true

class Sonar
  def initialize(input)
    @input = input
  end

  def self.increments(data)
    data.each_cons(2).map{|a, b| b > a ? 1 : 0}.sum
  end

  def self.sliding_increments(data)
    increments(data.each_cons(3).map(&:sum))
  end
end

if __FILE__ == $0
  filename = "01_input.txt"
  input = File.readlines(filename).map(&:to_i)

  puts "larget count: "
  puts Sonar.increments(input)
  puts "sliding count: "
  puts Sonar.sliding_increments(input)
end
