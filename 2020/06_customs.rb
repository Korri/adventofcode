# frozen_string_literal: true

class CustomsForm
  def initialize(data)
    @data = data.split("\n")
  end

  def count
    @data.join('').split('').uniq.count
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
    forms.map(&:count).sum
  end
end

if __FILE__ == $0
  filename = "06_input.txt"
  input = File.read(filename)
  customs = Customs.new(input.split("\n\n"))
  puts customs.part_one
end
