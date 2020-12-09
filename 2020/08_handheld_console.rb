# frozen_string_literal: true

class HandheldConsole
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
    instruction = @instructions[line]
    return @accumulator if instruction.nil?
    op, amount = instruction.split(' ')
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

class Debugger
  def initialize(instructions)
    @instructions = instructions
  end

  def debug(line = 0)
    begin
      code = @instructions.dup
      code[line] = code[line].sub('nop', 'jmp').sub('jmp', 'nop')
      return HandheldConsole.new(code).run
    rescue RuntimeError
      debug(line + 1)
    end
  end
end

if __FILE__ == $0
  filename = "08_input.txt"
  input = File.read(filename)
  console = Debugger.new(input.split("\n"))
  puts console.debug
end
