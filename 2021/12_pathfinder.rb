# frozen_string_literal: true

class Map
    def initialize(lines)
        paths = lines.map { |line| line.split("-") }
        @neightboors = {}
        paths.each do |path|
            add_path(path.first, path.last)
            add_path(path.last, path.first)
        end
        puts @neightboors.inspect
    end

    def add_path(from, to)
        @neightboors[from] ||= []
        @neightboors[from] << to
    end

    def options(room)
        @neightboors[room] || []
    end
end

class Path
    attr_accessor :steps
    def initialize
        @steps = []
    end

    def blocklist
        @steps.select{|room| room.upcase != room}
    end

    def add_step(step)
        @steps << step
    end

    def last
        @steps.last
    end

    def to_s
        @steps.join(",")
    end

    def initialize_copy(other)
        @steps = other.steps.clone
    end
end

class Pathfinder
    def initialize(lines)
        @map = Map.new(lines)
    end

    def all_paths
        path = Path.new
        path.add_step("start")
        next_steps(path)
    end

    def next_steps(path)
        @map.options(path.last).flat_map do |room|
            next if path.blocklist.include?(room)
            new_path = path.dup
            new_path.add_step(room)
            next [new_path] if room == "end"
            next_steps(new_path)
        end.compact
    end
end

if __FILE__ == $0
  filename = "12_input.txt"
  input = File.readlines(filename).map(&:strip)

  pathfinder = Pathfinder.new(input)
#   pathfinder.all_paths.map{|path| puts path.to_s}
  puts pathfinder.all_paths.count
end
