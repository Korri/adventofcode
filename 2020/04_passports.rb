# frozen_string_literal: true

class Passport
  REQUIRED = [
    'byr', # (Birth Year)
    'iyr', # (Issue Year)
    'eyr', # (Expiration Year)
    'hgt', # (Height)
    'hcl', # (Hair Color)
    'ecl', # (Eye Color)
    'pid', # (Passport ID)
  # 'cid', # (Country ID)
  ]

  def initialize(fields)
    @fields = parse(fields)
  end

  def valid?
    (REQUIRED - @fields.keys).empty?
  end

  private

  def parse(data)
    Hash[data.map{|field| field.split(':')}]
  end
end

class Passports
  def initialize(input)
    @passports = parse(input)
  end

  def part_one
    @passports.count(&:valid?)
  end

  private

  def parse(input)
    input
      .split("\n\n")
      .map{|passport| Passport.new(passport.split(/\s+/))}
  end
end

if __FILE__ == $0
  filename = "04_input.txt"
  input = File.read(filename)
  passports = Passports.new(input)
  puts passports.part_one
end
