# frozen_string_literal: true

class Range
  attr_reader :start, :size
  def initialize(start, size)
    @start = start
    @size = size
  end

  def end
    @start + @size - 1
  end

  def <=>(other)
    @start <=> other.start
  end

  def to_s
    "#{@start}-#{self.end}"
  end
end

class RangeMap
  def initialize(origin, destination, size)
    @origin = Range.new(origin, size)
    @offset = destination - origin
  end

  def map(seed)
    umapped = []
    mapped = []
    if seed.start < @origin.start
      umapped << Range.new(seed.start, [@origin.start - 1, seed.end].min - seed.start + 1)
    end

    if seed.end > @origin.end
      start = [@origin.end + 1, seed.start].max
      umapped << Range.new(start, seed.end - start + 1)
    end

    if seed.start < @origin.end && seed.end > @origin.start
      start = [@origin.start, seed.start].max
      size = [@origin.end, seed.end].min - start + 1
      mapped << Range.new(start + @offset, size)
    end

    [umapped, mapped]
  end
end

class Map
  attr_reader :name
  def self.from_string(string)
    name, *ranges = string.split("\n")
    mappings = ranges.map do |range|
      destination, origin, size = range.split(" ").map(&:to_i)
      RangeMap.new(origin, destination, size)
    end
    new(name, mappings)
  end

  def initialize(name, mappings)
    @name = name
    @mappings = mappings
  end

  def map(seeds)
    result = []
    @mappings.each do |mapping|
      seeds = seeds.map do |seed|
        unmapped, mapped = mapping.map(seed)
        result << mapped
        unmapped
      end.flatten
    end
    result << seeds
    result.flatten
  end
end

if __FILE__ == $0
  filename = "05_input.txt"
  parts = File.read(filename).split("\n\n")
  seeds = parts.shift.split(" ")[1..].map(&:to_i).each_slice(2).to_a.map do |seed, size|
    Range.new(seed, size)
  end.sort
  maps = parts.map { |part| Map.from_string(part) }
  maps.each do |map|
    seeds = map.map(seeds)
  end

  puts seeds.map(&:start).min
end
