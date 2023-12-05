# frozen_string_literal: true


if __FILE__ == $0
  filename = "01_input.txt"
  result = File.readlines(filename).map do |line|
    digits = []
    line.chars.each_with_index.map do |char, char_index|
      %w(one two three four five six seven eight nine).each_with_index do |word, index|
        digits << index + 1 if char.to_i == index + 1
        digits << index + 1 if word == line[char_index..char_index + word.length - 1]
      end
    end

    "#{digits[0]}#{digits[-1]}"
  end
  result = result.map(&:to_i).sum

  puts result
end
