import Foundation

struct DayX: AdventDay {

    // MARK: -

    func defaultInput() -> String? {
        return ""
    }

    func run(_ input: String? = nil) {
        guard let runInput = input ?? defaultInput() else {
            print("Day X: 💥 NO INPUT")
            exit(10)
        }

        let thing = partOne(input: runInput)
        guard let answer = thing else {
            print("Day X: (Part 1) 💥 Unable to calculate answer.")
            exit(1)
        }
        print("Day X: (Part 1) Answer ", answer)

        // ...
    }

    // MARK: -

    func partOne(input: String) -> Int? {
        return nil
    }

    func partTwo(input: String) -> Int? {
        return nil
    }
}

extension DayX: Testable {
    func runTests() {
        let input = ""

        guard
            testValue(0, equals: partOne(input: input))
            else {
                print("Part 1 Tests Failed!")
                return
        }

        guard
            testValue(0, equals: partTwo(input: input))
            else {
                print("Part 2 Tests Failed!")
                return
        }

        print("Done with tests... all pass")
    }
}


