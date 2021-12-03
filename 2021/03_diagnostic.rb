# frozen_string_literal: true

class Diagnostic
  def initialize(input)
    @input = input
  end

  def bits
    @bits ||= begin
      @input.map{|item| item.split("") }.transpose.map do |column|
        column.max_by {|i| column.count(i)}
      end
    end
  end

  def gamma
    bits.join("").to_i(2)
  end

  def epsilon
    bits.map{|i| i == "1" ? 0 : 1}.join("").to_i(2)
  end
end

if __FILE__ == $0
  filename = "03_input.txt"
  input = File.readlines(filename).map(&:strip)

  diag = Diagnostic.new(input)
  puts diag.gamma
  puts diag.epsilon
  puts diag.gamma * diag.epsilon
end
