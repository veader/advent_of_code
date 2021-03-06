//
//  DayTwentyOneTests.swift
//  Test
//
//  Created by Shawn Veader on 12/22/20.
//

import XCTest

class DayTwentyOneTests: XCTestCase {

    func testFooParsing() {
        var food: Food?

        food = Food("blasfda1231215")
        XCTAssertNil(food)

        food = Food("mxmxvkd kfcds sqjhc nhms (contains dairy, fish)")
        XCTAssertNotNil(food)
        XCTAssertEqual(4, food?.ingredients.count)
        XCTAssert(food!.ingredients.contains("nhms"))
        XCTAssertEqual(2, food?.knownAllergens.count)

        food = Food("trh fvjkl sbzzf mxmxvkd (contains dairy)")
        XCTAssertNotNil(food)
        XCTAssertEqual(4, food?.ingredients.count)
        XCTAssert(food!.ingredients.contains("sbzzf"))
        XCTAssertEqual(1, food?.knownAllergens.count)
    }

    func testGroceries() {
        let groceries = Groceries(testInput)
        XCTAssertEqual(4, groceries.foods.count)
        XCTAssertEqual(3, groceries.allergens.count)
        XCTAssertEqual(7, groceries.ingredients.count)
    }

    func testGroceryFindSafeIngredientsCount() {
        let groceries = Groceries(testInput)
        let count = groceries.safeIngredientAppearanceCount()
        XCTAssertEqual(5, count)
    }

    func testGroceriesSafeIngredients() {
        let groceries = Groceries(testInput)
        let safe = groceries.findSafeIngredients()
        XCTAssertEqual(4, safe.count)
    }

    func testGroceriesDangerousIngredients() {
        let groceries = Groceries(testInput)
//        let dangerous = groceries.findDangerousIngredients()
//        XCTAssertEqual(3, dangerous.count)
    }

    let testInput = """
        mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
        trh fvjkl sbzzf mxmxvkd (contains dairy)
        sqjhc fvjkl (contains soy)
        sqjhc mxmxvkd sbzzf (contains fish)
        """
}
