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

  def fields_order(tickets)
    tickets = tickets.map{|string| string.split(',').map(&:to_i)}
    tickets = tickets.select{|ticket| valid_ticket?(ticket) }

    rule_names = @rules.map(&:name)
    fields_validity = tickets[0].map{rule_names.dup}

    tickets.each do |ticket|
      ticket.each_with_index do |value, index|
        fields_validity[index] = fields_validity[index] & valid_rule_names(value)
      end
    end

    reduce_rules(fields_validity)
  end

  def ticket_error_rate(ticket)
    fields = ticket.split(',').map(&:to_i)
    error_fields = fields.reject { |field| valid_value?(field) }
    error_fields
  end

  private

  def reduce_rules(validity)
    while validity.map{|field| field.count}.max > 1
      settled_rules = validity.select{|rules| rules.count == 1}.map(&:first)
      validity = validity.map do |rules|
        next rules if rules.count == 1
        rules - settled_rules
      end
    end

    validity.map(&:first)
  end

  def valid_ticket?(fields)
    fields.all? { |field| valid_value?(field) }
  end

  def valid_rule_names(value)
    @rules.select { |rule| rule.valid?(value) }.map(&:name)
  end

  def valid_value?(value)
    @rules.any? { |rule| rule.valid?(value) }
  end

end

if __FILE__ == $0
  filename = "16_input.txt"
  rules, ticket, nearby = File.read(filename).split("\n\n")
  ticket = ticket.split("\n")[1].split(',').map(&:to_i)
  nearby = nearby.split("\n")[1..]

  validator = TicketValidator.new(rules.split("\n"))
  error_rate = nearby.sum { |ticket| validator.ticket_error_rate(ticket).sum }

  puts "Error rate: #{error_rate}"
  field_names = validator.fields_order(nearby)
  values =field_names.each_with_index.map do |rule_name, index|
    rule_name[0..8] == 'departure' ? ticket[index] : 1
  end
  puts "Ticket Factor: #{values.reduce(1, &:*)}"
end
