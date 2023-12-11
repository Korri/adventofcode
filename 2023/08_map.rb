class Map
  def self.from_string(directions, string)
    steps = string.split("\n")
    hash = steps.map do |step|
      from, to = step.split(" = ")
      to = to.scan(/[A-Z0-9]+/).to_a

      [from, to]
    end.to_h

    new(directions, hash)
  end

  def initialize(directions, hash)
    @directions = directions
    @hash = hash
  end

  def steps_required(starting_position = 'AAA', target = 'ZZZ')
    steps = 0
    position = starting_position
    while (!position.match(target))
      position = next_position(position, next_direction)
      steps += 1
    end

    steps
  end

  def guost_steps_required
    cycle_steps = @hash
      .select{|key| key.chars.last == 'A'}
      .tap{|hash| p hash }
      .map{|key, _| [key, steps_required(key, /..Z/)] }
      .to_h

    p cycle_steps

    cycle_steps.values.reduce(1){|lcm, steps| lcm.lcm steps}
  end

  def next_position(position, direction)
    @hash[position][direction == 'L' ? 0 : 1]
  end

  def next_direction
    @directions.first.tap do |direction|
      @directions.rotate!
    end
  end
end

if __FILE__ == $0
  filename = "08_input.txt"
  directions, instructions = File.read(filename).split("\n\n")

  directions = directions.split('')
  map = Map.from_string(directions, instructions)

  # p map.steps_required
  p map.guost_steps_required
end
