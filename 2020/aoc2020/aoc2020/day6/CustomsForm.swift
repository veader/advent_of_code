//
//  CustomsForm.swift
//  aoc2020
//
//  Created by Shawn Veader on 12/6/20.
//

import Foundation

struct CustomsForm {

    let groupSize: Int
    let reponses: [String]
    let answers: [String: Int]

    var yesQuestions: Int {
        answers.keys.count
    }

    init(_ input: String) {
        let people = input.split(separator: "\n").map(String.init)
        groupSize = people.count
        reponses = people

        var tmpAnswers = [String: Int]()
        for person in people {
            Array(person).map(String.init).forEach { q in
                tmpAnswers[q] = (tmpAnswers[q] ?? 0) + 1
            }
        }
        answers = tmpAnswers
    }
}
