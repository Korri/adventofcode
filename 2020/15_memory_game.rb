class MemoryGame
  def initialize(numbers)
    @numbers = numbers
  end

  def [](key)
    if @numbers.length < key
      (key + 1 - @numbers.length).times do
        @numbers << compute_next_number
      end
    end

    @numbers[key]
  end

  private

  def compute_next_number
    last = @numbers.last
    sub_list = @numbers[0..-2]
    return 0 unless sub_list.include?(last)
    @numbers.length - sub_list.rindex(last) - 1
  end
end

if __FILE__ == $0
  filename = "15_input.txt"
  input = File.read(filename).split("\n")
  input.each do |data|
    result = MemoryGame.new(data.split(',').map(&:to_i))[2019]
    puts "#{data}: #{result.inspect}"
  end
end
