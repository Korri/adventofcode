class Rules
  def initialize(rules)
    parse_rules(rules)
  end

  def valid?(string)
    @rule.match?(string)
  end

  private

  def parse_rules(rules)
    zip = rules.map{|line| line.split(': ')}.map{|array| [array[0].to_i, array[1]]}
    @rule_hash = Hash[zip]
    @rule = Regexp.new "^#{parse_rule(0)}$"
  end

  def parse_rule(index)
    string = @rule_hash[index]
    return string[1] if string[0] == '"'

    string.gsub!(/\d+/) do |number|
      parse_rule(number.to_i)
    end
    string.gsub!(/\s+/, '')
    return string unless string.include?('|')
    "(#{string})"
  end
end

if __FILE__ == $0
  filename = "19_input.txt"
  input = File.read(filename)
  rules_string, messages = input.split("\n\n")
  rules = Rules.new(rules_string.split("\n"))

  p messages.split("\n").count{|message| rules.valid?(message)}
end
