# frozen_string_literal: true

class Seat
  def initialize(binary_partitioning)
    @binary = binary_partitioning
  end

  def row
    binary_split(@binary[0..6], 127)
  end

  def column
    binary_split(@binary[-3..-1], 8)
  end

  def id
    row * 8 + column
  end

  def to_s
    "Hash #{@binary} row #{row}, column #{column}, seat ID #{id}"
  end

  def position
    [row, column]
  end

  private

  def binary_split(letters, count)
    letters.split('').reduce([0, count]) do |range, letter|
      if letter == 'F' || letter == 'L'
        [range[0], (range[1] - range[0]) / 2 + range[0]]
      else
        [((range[1] - range[0]) / 2.0).ceil + range[0], range[1]]
      end
    end[0]
  end
end

class Plane
  def initialize(input)
    @seats = input.map{|hash| Seat.new(hash.chomp)}
  end

  def part_one
    @seats.sort_by{|seat| seat.id }.last
  end

  def part_two
    127.times do |row|
      8.times do |column|
        id = row * 8 + column
        print seat_exists?(id)  ? " #{id.to_s.rjust(3, ' ')} " : '     '
      end
      puts
    end
  end

  private


  def seat_exists?(id)
    #puts "Seat #{id} exists? " + ( !@seats.find{|seat| seat.id == id}.nil? ? 'yes' : 'no')
    !@seats.find{|seat| seat.id == id}.nil?
  end
end

if __FILE__ == $0
  filename = "05_input.txt"
  input = File.readlines(filename)
  plane = Plane.new(input)
  plane.part_two
end
