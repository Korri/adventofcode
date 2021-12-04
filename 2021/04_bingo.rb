# frozen_string_literal: true
class Board
  def initialize(lines)
    @rows = lines.split("\n").map{ |line| line.split(" ").map(&:to_i) }
    @columns = @rows.transpose
    @combined = @rows + @columns
  end

  def wins?(numbers)
    @combined.map{|entry| entry - numbers}.any?(&:empty?)
  end

  def score(numbers)
    @rows.map{|entry| entry - numbers}.flatten.sum * numbers.pop
  end
end


class Bingo
  def initialize(input)
    parts = input.split("\n\n")
    @numbers = parts.shift.split(",").map(&:to_i)
    @boards = parts.map{|part| Board.new(part)}
  end

  def winner_score
    (0..@numbers.length).each do |index|
      drawn_numbers = @numbers[0..index]
      winner = @boards.find{|board| board.wins?(drawn_numbers)}
      return winner.score(drawn_numbers) unless winner.nil?
    end
  end

  def looser_score
    (0..@numbers.length).each do |index|
      drawn_numbers = @numbers[0..index]
      loosers = @boards.reject{|board| board.wins?(drawn_numbers)}
      if loosers.length == 1
        looser = loosers.first
        (index..@numbers.length).each do |i|
          drawn_numbers = @numbers[0..i]
          return looser.score(drawn_numbers) if looser.wins?(drawn_numbers)
        end
      end
    end
  end
end

if __FILE__ == $0
  filename = "04_input.txt"
  input = File.read(filename)

  bingo = Bingo.new(input)
  puts bingo.winner_score
  puts bingo.looser_score
end
