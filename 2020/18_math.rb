module Math
  PARENTHESES = /\(([^)(]+)\)/
  OPERATION = /(\d+)([-+*\/])(\d+)/

  def self.eval(expr)
    expr = expr.dup.gsub(/\s+/, '')

    while expr.match(PARENTHESES) do
      expr = expr.sub(PARENTHESES) { self.eval($1) }
    end

    while expr.match(OPERATION) do
      expr = expr.sub(OPERATION) do
        a, op, b = $1.to_i, $2, $3.to_i
        a.send(op, b)
      end
    end
    expr.to_i
  end
end

if __FILE__ == $0
  filename = "18_input.txt"
  input = File.read(filename)

  puts input.split("\n").sum{|operation| Math.eval(operation) }
end
