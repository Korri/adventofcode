# frozen_string_literal: true

class HandheldConsole
  DEBUG = false
  def initialize(instructions)
    @instructions = instructions
    @executed = []
    @next_line = 0
    @accumulator = 0
  end

  def run(line = 0)
    raise "Infinite loop with Accumulator=#{@accumulator}! Was gonna call #{line} a second time!" if @executed[line]
    @executed[line] = true
    @next_line = line + 1
    op, amount = @instructions[line].split(' ')
    if DEBUG
      puts "Executing #{line}: #{op} #{amount.to_i} (accumulator #{@accumulator})"
      sleep 1
    end
    send(op, amount.to_i)
    run(@next_line)
  end

  private

  def nop(_)
  end

  def acc(amount)
    @accumulator += amount
  end

  def jmp(amount)
    @next_line += amount - 1
  end
end

if __FILE__ == $0
  filename = "08_input.txt"
  input = File.read(filename)
  console = HandheldConsole.new(input.split("\n"))
  puts console.run
end
