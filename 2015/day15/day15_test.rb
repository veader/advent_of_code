#!/usr/bin/env ruby

require "pp"
require_relative "day15"

data = "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"

recipe = CookieRecipe.new(data, 100, 500)
pp recipe.ingredients

# p "="*80
# score = recipe.calculate_mix_score({ "Butterscotch" => 44, "Cinnamon" => 56 })
# raise "Score incorrect. Expected 62842880, got #{score}" unless score == 62842880
# p "Score for ratio 44/56 is #{score}"

p "="*80
pp recipe.determine_optimal_mix
