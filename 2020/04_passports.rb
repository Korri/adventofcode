# frozen_string_literal: true

class Passport

  HEIGHT_RANGES = {
    'cm' => [150, 193],
    'in' => [59, 76],
  }

  REQUIRED = {
    'byr' => -> (field) { field.to_i.between?(1920, 2002) }, # (Birth Year)
    'iyr' => -> (field) { field.to_i.between?(2010, 2020) }, # (Issue Year)
    'eyr' => -> (field) { field.to_i.between?(2020, 2030) }, # (Expiration Year)
    'hgt' => -> (field) { valid_height?(field) }, # (Height)
    'hcl' => -> (field) { field.match?(/^#[0-9a-f]{6}$/) }, # (Hair Color)
    'ecl' => -> (field) { %w(amb blu brn gry grn hzl oth).include?(field) }, # (Eye Color)
    'pid' => -> (field) { field.match?(/^[0-9]{9}$/) }, # (Passport ID)
    # 'cid', # (Country ID)
  }

  def initialize(fields)
    @fields = parse(fields)
  end

  def valid?
    return false unless (REQUIRED.keys - @fields.keys).empty?
    REQUIRED.each do |key, rule|
      return false unless rule.call(@fields[key])
    end
    true
  end

  private

  def parse(data)
    Hash[data.map { |field| field.split(':') }]
  end

  def self.valid_height?(field)
    unit = field[-2..-1]
    return false unless HEIGHT_RANGES.keys.include?(unit)
    field.to_i.between?(HEIGHT_RANGES[unit][0], HEIGHT_RANGES[unit][1])
  end
end

class Passports
  def initialize(input)
    @passports = parse(input)
  end

  def part_two
    @passports.count(&:valid?)
  end

  private

  def parse(input)
    input
      .split("\n\n")
      .map { |passport| Passport.new(passport.split(/\s+/)) }
  end
end

if __FILE__ == $0
  filename = "04_input.txt"
  input = File.read(filename)
  passports = Passports.new(input)
  puts passports.part_two
end
