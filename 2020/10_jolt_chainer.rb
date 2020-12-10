# frozen_string_literal: true

class JoltChainer
  def initialize(adapters)
    @adapters = adapters.sort
    @jolts = 0
    @jumps = {
      1 => 0,
      2 => 0,
      3 => 1,
    }
  end

  def chain
    next_adapter = @adapters.find{|adapter| adapter <= @jolts + 3}
    @adapters -= [next_adapter]
    @jumps[next_adapter - @jolts] += 1
    @jolts = next_adapter

    return @jumps if @adapters.empty?

    chain
  end
end

if __FILE__ == $0
  filename = "10_input.txt"
  input = File.read(filename)
  console = JoltChainer.new(input.split("\n").map(&:to_i))
  jumps = console.chain
  p jumps
  p jumps[1] * jumps[3]
end
