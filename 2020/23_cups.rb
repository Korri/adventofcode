class Cups
  def initialize(cups)
    @cups = cups.split(//).map(&:to_i)
  end

  def tick
    current_cup = @cups.shift
    trio = @cups.shift(3)
    previous = @cups.select{|cup| cup < current_cup}.max || @cups.max
    @cups = @cups.insert(@cups.index(previous) + 1, *trio) + [current_cup]
  end

  def solve(times)
    times.times do
      tick
    end
    @cups
  end
end

if __FILE__ == $0
  p Cups.new('389125467').solve(10)
  p Cups.new('589174263').solve(100)
end
