# frozen_string_literal: true

class Parser
  SCORES = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }

  PAIRS = {
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">",
  }

  def initialize(line)
    @line = line
  end

  def first_invalid_character_score
    blocks =  []
    @line.chars.each do |char|
      if PAIRS.keys.include?(char)
        blocks << char
      elsif PAIRS.values.include?(char)
        if PAIRS[blocks.last] == char
          blocks.pop
        else
          return SCORES[char]
        end
      end
    end
    return 0
  end
end

if __FILE__ == $0
  filename = "10_input.txt"
  input = File.readlines(filename).map { |line| Parser.new(line.strip) }

  puts input.sum(&:first_invalid_character_score)
end
