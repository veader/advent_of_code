#!/usr/bin/env ruby

require "pp"

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

  def determine_optimal_mix(fixed_ratio={}, moving=self.ingredients)
    # if we've fixed all pieces, calculate and bubble back up
    if moving.empty?
      p "Reached end. Calculating... #{fixed_ratio}"
      return [calculate_mix_score(fixed_ratio), fixed_ratio]
    end

    scores = {}
    remainder = moving.dup
    next_ingredient = remainder.shift

    # max size this ingredient can be given others in ratio
    max = max_size_for_ingredient(next_ingredient.name, fixed_ratio)

    min = 0
    # if we are the last one, there really is only one size for us...
    min = max if remainder.empty?

    max.downto(min) do |tbsp|
      # TODO: don't do work if ingredient sizes don't equal total needed
      score, ratio = determine_optimal_mix(fixed_ratio.merge({ next_ingredient.name => tbsp }), remainder)
      scores[score] ||= []
      scores[score] << ratio
    end

    score = scores.keys.sort.last
    [score, scores[score]]
  end

  def max_size_for_ingredient(name, ratio={})
    used = ratio.collect { |ingredient, tbsp| ingredient == name ? 0 : tbsp }
    self.tablespoons - used.reduce(0, :+)
  end

  def min_size_for_ingredient(name, ratio={})
  end

  def calculate_mix_score(ratios={})
    ratio_used_tbsp = ratios.collect { |name, tbsp| tbsp }.reduce(0, :+)
    return 0 if ratio_used_tbsp < self.tablespoons # don't bother unless ratio is legit

    scores = \
      params.collect do |param|
        values = \
          ingredients.collect do |i|
            i.send(param) * ratios[i.name]
          end
        score = values.reduce(0, :+)
        score = 0 if score < 0
        score
      end
    scores.reduce(:*)
  end
end

if __FILE__ == $0
  input = ARGV[0]
  recipe = CookieRecipe.new(input)
  pp recipe.ingredients
  p "="*80
  pp recipe.determine_optimal_mix
end
