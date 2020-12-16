class ValidationRule
  attr_reader :name

  def initialize(rule)
    @name, ranges = rule.split(': ')
    @ranges = ranges.split(' or ').map { |rule| rule.split('-').map(&:to_i) }
  end

  def valid?(value)
    @ranges.any? { |range| value.between?(*range) }
  end
end

class TicketValidator
  def initialize(rules)
    @rules = rules.map { |line| ValidationRule.new(line) }
  end

  def valid?(ticket)
    fields = ticket.split(',').map(&:to_i)
    fields.all? { |field| valid_value?(field) }
  end

  def ticket_error_rate(ticket)
    fields = ticket.split(',').map(&:to_i)
    error_fields = fields.reject { |field| valid_value?(field) }
    error_fields
  end

  private

  def valid_value?(value)
    @rules.any? { |rule| rule.valid?(value) }
  end

end

if __FILE__ == $0
  filename = "16_input.txt"
  rules, ticket, nearby = File.read(filename).split("\n\n")
  ticket = ticket.split("\n")[1]
  nearby = nearby.split("\n")[1..]

  validator = TicketValidator.new(rules.split("\n"))
  error_rate = nearby.sum { |ticket| validator.ticket_error_rate(ticket).sum }

  puts "Error rate: #{error_rate}"
end
