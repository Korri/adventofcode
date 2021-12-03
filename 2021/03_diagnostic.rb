# frozen_string_literal: true

class Diagnostic
  def initialize(input)
    @input = input
  end

  def transposed
    @input.map{|item| item.split("") }.transpose
  end

  def bits
    @bits ||= begin
      transposed.map do |column|
        column.max_by {|i| column.count(i)}
      end
    end
  end

  def flipped_ints
    @flipped_ints ||= @input.map{|i| i.reverse.to_i(2)}
  end

  def gamma
    bits.join("").to_i(2)
  end

  def epsilon
    bits.map{|i| i == "1" ? 0 : 1}.join("").to_i(2)
  end

  def oxygen
    gaz(:max_by)
  end

  def co2
    gaz(:min_by)
  end

  def gaz(method)
    bits = ""
    matches = @input
    while matches.length > 1
      columns = matches.map{|item| item.split("") }.transpose
      column = columns[bits.length]
      bits += column.send(method){|i| column.count(i) + i.to_f/2}
      matches = find_matches(matches, bits)
    end
    matches[0].to_i(2)
  end

  def find_matches(matches, bits)
    matches.select { |i| i.start_with?(bits) }
  end
end

if __FILE__ == $0
  filename = "03_input.txt"
  input = File.readlines(filename).map(&:strip)

  diag = Diagnostic.new(input)
  puts diag.gamma
  puts diag.epsilon
  puts diag.gamma * diag.epsilon


  puts diag.oxygen
  puts diag.co2
  puts diag.oxygen * diag.co2
end
