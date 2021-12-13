# frozen_string_literal: true

class Parser
  INVALID_SCORES = {
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137,
  }
  MISSING_SCORES = {
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4,
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

  def valid?
    first_invalid_character_score == 0
  end

  def first_invalid_character_score
    blocks = []
    @line.chars.each do |char|
      if PAIRS.keys.include?(char)
        blocks << char
      elsif PAIRS.values.include?(char)
        if PAIRS[blocks.last] == char
          blocks.pop
        else
          return INVALID_SCORES[char]
        end
      end
    end
    return 0
  end

  def missing_characters
    blocks = []
    @line.chars.each do |char|
      if PAIRS.keys.include?(char)
        blocks << char
      elsif PAIRS.values.include?(char)
        if PAIRS[blocks.last] == char
          blocks.pop
        else
          raise "Invalid line: #{@line}"
        end
      end
    end
    blocks.reverse.map { |char| PAIRS[char] }
  end

  def missing_characters_score
    missing_characters.reduce(0) do |score, char|
      score * 5 + MISSING_SCORES[char]
    end
  end
end

if __FILE__ == $0
  filename = "10_input.txt"
  input = File.readlines(filename).map { |line| Parser.new(line.strip) }

  puts input.sum(&:first_invalid_character_score)

  scores = input.select(&:valid?).map(&:missing_characters_score).sort
  puts scores[scores.size / 2]
end
