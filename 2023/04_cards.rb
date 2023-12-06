# frozen_string_literal: true

class Card
  attr_reader :id
  attr_accessor :count

  def initialize(id, winning_numbers, my_numbers)
    @id = id
    @winning_numbers = winning_numbers
    @my_numbers = my_numbers
    @count = 1
  end

  def self.from_string(string)
    name, numbers = string.split(": ")
    id = name.split(" ").last.to_i
    winning_numbers, my_numbers = numbers.split(" | ")
    winning_numbers = winning_numbers.split(" ").map(&:to_i)
    my_numbers = my_numbers.split(" ").map(&:to_i)

    new(id, winning_numbers, my_numbers)
  end

  def score
    return 0 if matches == 0

    2 ** (matches - 1)
  end

  def matches
    (@winning_numbers & @my_numbers).length
  end
end

class Game
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.from_string(lines)
    cards = lines.map do |line|
      Card.from_string(line)
    end

    new(cards)
  end

  def total_cards
    @cards.each_with_index do |card, index|
      (1..card.matches).each do |i|
        next if index + i >= @cards.length

        @cards[index + i].count += card.count
      end
    end

    @cards.map(&:count).sum
  end
end

if __FILE__ == $0
  filename = "04_input.txt"
  game = Game.from_string(File.readlines(filename))

  p game.cards.map(&:score).sum
  p game.total_cards
end
