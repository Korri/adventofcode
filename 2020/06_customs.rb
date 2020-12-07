# frozen_string_literal: true

class CustomsForm
  def initialize(data)
    @data = data.split("\n")
  end

  def count_anyone
    @data.join('').split('').uniq.count
  end

  def count_everyone
    @data.map { |line| line.split('') }.inject(&:&).count
  end
end

class Customs
  def initialize(input)
    @input = input
  end

  def forms
    @forms ||= @input.map{|input| CustomsForm.new(input) }
  end

  def part_one
    forms.map(&:count_anyone).sum
  end

  def part_two
    forms.map(&:count_everyone).sum
  end
end

if __FILE__ == $0
  filename = "06_input.txt"
  input = File.read(filename)
  customs = Customs.new(input.split("\n\n"))
  puts customs.part_one
  puts customs.part_two
end
