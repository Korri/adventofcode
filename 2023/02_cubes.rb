# frozen_string_literal: true

class Pull
  attr_reader :color, :count
  def initialize(color, count)
    @color = color
    @count = count
  end
end

class PullSet
  attr_reader :red, :green, :blue
  def initialize(red = 0, green = 0, blue = 0)
    @red = red
    @green = green
    @blue = blue
  end

  def <<(pull)
    case pull.color
    when "red"
      @red += pull.count
    when "green"
      @green += pull.count
    when "blue"
      @blue += pull.count
    end
  end

  def possible?(red, green, blue)
    @red <= red && @green <= green && @blue <= blue
  end

  def power
    @red * @green * @blue
  end
end

class Game
  attr_reader :id, :pulls
  def initialize(id, pulls)
    @id = id
    @pulls = pulls
  end

  def self.from_string(string)
    name, pulls = string.split(": ")
    id = name.split(" ").last.to_i

    pulls = pulls.split("; ").map do |pull|
      pull_set = PullSet.new
      kinds = pull.split(", ").map do |kind|
        pull_set << Pull.new(kind.split(" ").last, kind.split(" ").first.to_i)
      end
      pull_set
    end

    new(id, pulls)
  end

  def possible?(red, green, blue)
    pulls.all? do |pull|
      pull.possible?(red, green, blue)
    end
  end

  def max_per_color
    maxes = pulls.map do |pull|
      [pull.red, pull.green, pull.blue]
    end.transpose.map(&:max)

    PullSet.new(*maxes)
  end
end
if __FILE__ == $0
  filename = "02_input.txt"
  games = File.readlines(filename).map do |line|
    Game.from_string(line)
  end

  p games.filter{|game| game.possible?(12, 13, 14)}.sum(&:id)
  p games.map(&:max_per_color).sum(&:power)
end
