# frozen_string_literal: true

class Part
  def initialize(string, line_index, char_index)
    @string = string
    @line_index = line_index
    @char_index = char_index
  end

  def is_at?(line_index, char_index)
    return false unless @line_index == line_index

    (@char_index..@char_index + @string.length - 1).include?(char_index)
  end

  def to_i
    @string.to_i
  end
end

class Map
  def initialize(string)
    @map = string.split("\n").map do |line|
      line.split("")
    end
  end

  def gears
    @gears ||= begin
      gears = []
      make_gears do |gear|
        gears << gear
      end
      gears
    end
  end

  def parts
    @parts ||= begin
      parts = []
      make_parts do |part|
        parts << part
      end
      parts
    end
  end

  def make_gears
    @map.each_with_index do |line, line_index|
      line.each_with_index do |char, char_index|
        next if char != '*'

        line_range, char_range = neightbouring_range(line_index, char_index)
        neightbour_parts = parts.select do |part|
          line_range.any? do |line_index|
            char_range.any? do |char_index|
              part.is_at?(line_index, char_index)
            end
          end
        end
        yield neightbour_parts[0].to_i * neightbour_parts[1].to_i if neightbour_parts.length == 2
      end
    end
  end

  def make_parts
    @map.each_with_index do |line, line_index|
      current_part = nil
      line.each_with_index do |char, char_index|
        if char.match(/\d/)
          current_part ||= ""
          current_part += char
        else
          part = is_part(current_part, line, line_index, char_index)
          yield part unless part.nil?
          current_part = nil
        end
      end
      part = is_part(current_part, line, line_index, line.length)
      yield part unless part.nil?
    end
  end

  def is_part(current_part, line, line_index, char_index)
    return nil if current_part.nil?

    neightbours = neightbours(line_index, char_index - current_part.length, current_part.length)

    return nil unless neightbours.flatten.any?{|char| char.match(/[^0-9\.]/)}

    Part.new(current_part, line_index, char_index - current_part.length)
  end

  def neightbours(line_index, char_index, part_length = 1)
    line_range, char_range = neightbouring_range(line_index, char_index, part_length)
    @map[line_range].map{|line| line[char_range]}
  end

  def neightbouring_range(line_index, char_index, part_length = 1)
    line_range = ([line_index-1, 0].max..[line_index+1, @map.length-1].min)
    char_range = ([char_index-1, 0].max..[char_index+part_length, @map[0].length-1].min)
    [line_range, char_range]
  end
end

if __FILE__ == $0
  filename = "03_input.txt"
  content = File.read(filename)
  map = Map.new(content)
  # p map.parts

  p map.gears.sum
end
