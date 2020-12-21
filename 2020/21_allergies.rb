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

  def figure_out_allergens
    data = @allergens.dup
    while data.values.map{|ingredient| ingredient.count}.max > 1
      found_ingredients = data.values.select{|ingredient| ingredient.count == 1}.map(&:first)
      data = data.map do |allergen, ingredients|
        next [allergen, ingredients] if ingredients.count == 1
        [allergen, ingredients - found_ingredients]
      end.to_h
    end

    data.map{|k, v| [k, v[0]]}.to_h
  end
end

if __FILE__ == $0
  input = File.read('21_input.txt')

  allergies = Allergies.new(input.split("\n"))
  p allergies.non_allergen_count
  allergens = allergies.figure_out_allergens

  p allergens.sort.to_h.values.join(',')
end
