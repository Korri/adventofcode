class MemoryGame
  def initialize(numbers)
    @last_number = nil
    @last_seen = {}
    @index = -1
    numbers.each do |number|
      store_number(number)
    end
  end

  def [](key)
    (key - @index).times do
      store_number(compute_next_number)
    end

    @last_number
  end

  private

  def compute_next_number
    return 0 if @last_seen[@last_number].nil?
    @index - @last_seen[@last_number]
  end

  def store_number(number)
    @last_seen[@last_number] = @index unless @last_number.nil?
    @last_number = number
    @index += 1
  end
end

if __FILE__ == $0
  filename = "15_input.txt"
  input = File.read(filename).split("\n")
  input.each do |data|
    result = MemoryGame.new(data.split(',').map(&:to_i))[30000000-1]
    puts "#{data}: #{result.inspect}"
  end
end
