class Line
  def initialize(springs, counts)
    @springs = springs
    @counts = counts
  end

  def matches?(springs = @springs)
    # print springs.join
    # print " => "
    # print springs.join.scan(/#+/).map(&:size)
    # print "\ => "
    # print @counts
    # print "\n"
    springs.join.scan(/#+/).map(&:size) == @counts
  end

  def count_possible_arrangements
    unknown_count = @springs.count('?')
    p @springs.join
    ['.', '#'].repeated_permutation(unknown_count).count do |replacements|
      springs = @springs.map do |spring|
        next replacements.shift if spring == '?'
        spring
      end
      matches?(springs)
    end
  end
end

if __FILE__ == $0
  filename = "12_input.txt"
  lines = File.readlines(filename, chomp: true).map do |line|
    springs, counts = line.split(' ')
    Line.new(springs.split(''), counts.split(',').map(&:to_i))
  end

  p lines.sum(&:count_possible_arrangements)
end
