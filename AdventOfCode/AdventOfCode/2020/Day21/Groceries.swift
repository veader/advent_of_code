//
//  Groceries.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/24/20.
//

import Foundation

class Groceries {
    let foods: [Food]

    var allergens: [String: [Int]]
    var ingredients: [String: [Int]]

    init(_ input: String) {
        foods = input.split(separator: "\n")
                     .map(String.init).enumerated()
                     .compactMap { Food($1, id: $0) }

        allergens = [String: [Int]]()
        ingredients = [String: [Int]]()

        for food in foods {
            for allergen in food.knownAllergens {
                var alergyIndices = allergens[allergen] ?? []
                alergyIndices.append(food.identifier)
                allergens[allergen] = alergyIndices
            }

            for ingredient in food.ingredients {
                var ingredientIndices = ingredients[ingredient] ?? []
                ingredientIndices.append(food.identifier)
                ingredients[ingredient] = ingredientIndices
            }
        }
    }

    func findFood(with identifier: Int) -> Food? {
        foods.first(where: { $0.identifier == identifier })
    }

    func findSafeIngredients() -> [String] {
        let potentiallyDangerousIngredients = findPotentiallyDangerousIngredients()
        let allIngredients = ingredients.keys
        let safeIngredients = Set(allIngredients).subtracting(potentiallyDangerousIngredients)

        return Array(safeIngredients)
    }

    func findPotentiallyDangerousIngredients() -> [String] {
        // find foods that only have a single allergen
        let singleAllergenFoods = foods.filter { $0.knownAllergens.count == 1 }
        let singleAllergens = singleAllergenFoods.flatMap({ $0.knownAllergens }).unique()

        var possiblyDangerousIngredients = [String]()

        for allergen in singleAllergens {
            var initialSet = Set<String>()
            var ingredientSet = Set<String>()

            let matchingFoodIDs = allergens[allergen] ?? []
            let food = matchingFoodIDs.compactMap { findFood(with: $0) }

            // what ingredient(s) do all of these food have in common?
            let singleFoods = food.filter { $0.knownAllergens.count == 1 }
            initialSet = singleFoods.reduce(initialSet, { (result, food) in
                if result.count == 0 {
                    return Set(food.ingredients)
                } else {
                    return result.intersection(Set(food.ingredients))
                }
            })

            ingredientSet = food.reduce(initialSet, { (result, food) in
                result.intersection(Set(food.ingredients))
            })

            possiblyDangerousIngredients.append(contentsOf: ingredientSet)
        }

        return possiblyDangerousIngredients.unique().sorted()
    }

    /// Find the dangerous ingredients. Removing safe ingredients helps isolate the dangerous ones.
    func findDangerousIngredients() -> [String] {
        // let safeIngredients = findSafeIngredients() // TODO: did I leave off here?
        return []
    }

    func safeIngredientAppearanceCount() -> Int {
        let safeIngredients = findSafeIngredients()
        return safeIngredients.reduce(0) { $0 + (ingredients[$1] ?? []).count }
    }
}
