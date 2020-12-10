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
    @chains = []
    @chain_count_cache = {}
  end

  def chain
    next_adapter = @adapters.find{|adapter| adapter <= @jolts + 3}
    @adapters -= [next_adapter]
    @jumps[next_adapter - @jolts] += 1
    @jolts = next_adapter

    return @jumps if @adapters.empty?

    chain
  end

  def chain_counts(jolts)
    @chain_count_cache[jolts] ||= begin
      return 1 if jolts == @adapters.last
      next_adapters = @adapters.select{|adapter| adapter.between?(jolts + 1, jolts + 3)}
      next_adapters.sum {|next_adapter| chain_counts(next_adapter)}
    end
  end
end

if __FILE__ == $0
  filename = "10_input.txt"
  input = File.read(filename)
  # chainer = JoltChainer.new(input.split("\n").map(&:to_i))
  # jumps = chainer.chain
  # # p jumps
  # p jumps[1] * jumps[3]

  chainer = JoltChainer.new(input.split("\n").map(&:to_i))
  count = chainer.chain_counts(0)
  # chains.each{|chain| p chain }
  p count
end
