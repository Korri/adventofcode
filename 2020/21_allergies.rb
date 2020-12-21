class Allergies
  def initialize(food)
    @allergens = {}
    @ingredients = []
    food.each do |line|
      ingredients, allergens = line[0..-2].split(' (contains ')
      ingredients = ingredients.split(' ')
      allergens = allergens.split(', ')
      allergens.each do |allergen|
        @allergens[allergen] ||= ingredients
        @allergens[allergen] &= ingredients
      end
      @ingredients += ingredients
    end
  end

  def non_allergen_count
    non_allergens = @ingredients.uniq - @allergens.values.flatten.uniq
    non_allergens.sum{|ingredient| @ingredients.count(ingredient) }
  end
end

if __FILE__ == $0
  input = File.read('21_input.txt')

  allergies = Allergies.new(input.split("\n"))
  p allergies.non_allergen_count
end
