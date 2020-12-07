# frozen_string_literal: true

class Bag
  def initialize(string)
    @bag, contains = string.split(' bags contain ')

    if contains == 'no other bags.'
      @can_contain = []
    else
      @can_contain = contains[0..-2].split(', ').map do |contain|
        contain.sub(/ bags?/, '').split(' ', 2)
      end
    end
  end

  def type
    @bag
  end

  def allowed_types
    @can_contain.map(&:last)
  end

  def can_contain?(sub_type)
    allowed_types.include?(sub_type)
  end
end

class Luggage
  def initialize(rules)
    @bags = rules.map { |rule| Bag.new(rule) }
  end

  def part_one
    bags_that_can_contain('shiny gold').count
  end

  def part_two

  end

  def bags_that_can_contain(type)
    bags = @bags.select { |bag| bag.can_contain?(type) }.map(&:type)
    bags.reduce(bags) do |all, container|
      all + bags_that_can_contain(container)
    end.uniq
  end
end

if __FILE__ == $0
  filename = "07_input.txt"
  input = File.read(filename)
  luggages = Luggage.new(input.split("\n"))
  puts luggages.part_one
end
