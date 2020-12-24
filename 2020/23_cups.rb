require_relative './utils/circular_linked_list'

class Cups
  attr_accessor :cups

  def initialize(cups)
    @cups = CircularList.new
    @hash = {}
    @max = 0

    @last_node = nil
    cups.split(//).map(&:to_i).each do |cup|
      insert(cup)
    end
    @current_node = @cups.head
  end

  def tick
    trio = @cups.remove_nexts(@current_node, 3)
    previous_value = @current_node.data - 1
    while trio.map(&:data).include?(previous_value) || previous_value < 1
      previous_value = previous_value < 1 ? @max : previous_value - 1
    end
    previous_node = @hash[previous_value]
    @cups.insert_nexts(previous_node, trio)
    @current_node = @current_node.next
  end

  def solve(times)
    times.times do |index|
      tick
    end
    @cups
  end

  def fill(to)
    ((@max+1)..to).each { |value| insert(value) }
    self
  end

  def insert(value)
    @max = [@max, value].max
    @last_node = @hash[value] = @cups.insert_next(@last_node, value)
  end

  def next_two(index)
    node = @hash[index]
    [node, node.next, node.next.next].join(',')
  end
end

if __FILE__ == $0
  # puts Cups.new('389125467').solve(10)
  # puts Cups.new('589174263').solve(100)
  cups = Cups.new('589174263').fill(1_000_000)
  cups.solve(10_000_000)
  p cups.next_two(1)
end
