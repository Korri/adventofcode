# frozen_string_literal: true

class Bag
  def initialize(string)
    @bag, contains = string.split(' bags contain ')

    if contains == 'no other bags.'
      @can_contain = []
    else
      @can_contain = contains[0..-2].split(', ').map do |contain|
        contain.sub(/ bags?/, '').split(' ', 2).reverse
      end
    end
  end

  def type
    @bag
  end

  def allowed_types
    @can_contain.map(&:first)
  end

  def allowed_map
    Hash[@can_contain]
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
    count_bags('shiny gold') - 1
  end

  def find(type)
    @bags.find{|bag| bag.type == type}
  end

  def count_bags(type)
    bag = find(type)

    return 1 if bag.allowed_map.empty?

    1 + bag.allowed_map.map do |allowed_type, count|
      count.to_i * count_bags(allowed_type)
    end.sum
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
  puts luggages.part_two
end
