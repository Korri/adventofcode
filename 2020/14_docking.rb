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

  def run_part_two
    memory = {}
    @instuctions.each do |operation, slot, value|
      puts "#{operation}[#{slot}] = #{value}"
      if operation == 'mask'
        set_mask(value)
      else
        apply_mask_v2(slot.to_i).each do |masked_slot|
          puts "masked_mem[#{masked_slot}] = #{value}"
          memory[masked_slot] = value.to_i
        end
      end
    end
    memory.values
  end

  private

  def set_mask(mask)
    @mask = mask
    @and_mask = mask.gsub('X', '1').to_i(2)
    @or_mask = mask.gsub('X', '0').to_i(2)
  end

  def apply_mask(value)
    value & @and_mask | @or_mask
  end

  def apply_mask_v2(address)
    or_address = address | @or_mask
    permutations_count = @mask.count('X')
    ['0','1'].repeated_permutation(permutations_count).map do |bits|
      permutation_address = or_address.to_s(2).rjust(36, '0')
      @mask.split(//).each_with_index do |char, index|
        next unless char == 'X'
        permutation_address[index] = bits.pop
      end
      permutation_address.to_i(2)
    end
  end
end

if __FILE__ == $0
  filename = "14_input.txt"
  input = File.read(filename)
  instructions = input.scan(/(mem|mask)(?:\[(\d+)\])? = (.+)/)

  docking = Docking.new(instructions)
  p docking.run_part_two.sum { |val| val || 0 }
end
