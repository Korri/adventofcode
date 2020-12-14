class Docking
  def initialize(instructions)
    @instuctions = instructions
  end

  def run_part_one
    memory = []
    @instuctions.each do |operation, slot, value|
      puts "#{operation}[#{slot}] = #{value}"
      if operation == 'mask'
        set_mask(value)
      else
        memory[slot.to_i] = apply_mask(value.to_i)
      end
    end
    memory
  end

  private

  def set_mask(mask)
    @and_mask = mask.gsub('X', '1').to_i(2)
    @or_mask = mask.gsub('X', '0').to_i(2)
  end

  def apply_mask(value)
    value & @and_mask | @or_mask
  end
end

if __FILE__ == $0
  filename = "14_input.txt"
  input = File.read(filename)
  instructions = input.scan(/(mem|mask)(?:\[(\d+)\])? = (.+)/)

  docking = Docking.new(instructions)
  p docking.run_part_one.sum { |val| val || 0 }
end
