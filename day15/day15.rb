#!/usr/bin/env ruby

class CookieIngredient
  attr_accessor :name, :capacity, :durability, :flavor, :texture, :calories

  def initialize(input="")
    parse(input)
  end

  def parse(input)
    # http://rubular.com/r/3Z9MhDyWS1
    regex = /(\S+): (\S+) (\-?\d+), (\S+) (\-?\d+), (\S+) (\-?\d+), (\S+) (\-?\d+), (\S+) (\-?\d+)/
    return unless match = input.match(regex)

    caps = match.captures.dup
    self.name = caps.shift
    caps.each_slice(2) { |prop, val| self.send("#{prop}=", val.to_i) }
  end
end

class CookieRecipe
  attr_accessor :ingredients, :tablespoons

  def initialize(input="", tbsp=100)
    self.ingredients = []
    self.tablespoons = tbsp
    parse(input)
  end

  def parse(input)
    input.each_line { |line| self.ingredients << CookieIngredient.new(line) }
  end

  def params
    %i[capacity durability flavor texture]
  end

  def determine_optimal_mix(fixed=[])
  end

  def calculate_mix_score(ratios={})
    scores = \
      params.collect do |param|
        values = \
          ingredients.collect do |i|
            i.send(param) * ratios[i.name]
          end
        score = values.reduce(:+)
        score = 0 if score < 0
        p "Score: #{param} #{score}"
        score
      end
    scores.reduce(:*)
  end
end

if __FILE__ == $0
  input = ARGV[0]
  recipe = CookieRecipe.new(input)
end
