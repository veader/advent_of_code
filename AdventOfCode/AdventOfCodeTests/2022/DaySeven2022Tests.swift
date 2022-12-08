//
//  DaySeven2022Tests.swift
//  AdventOfCodeTests
//
//  Created by Shawn Veader on 12/7/22.
//

import XCTest

final class DaySeven2022Tests: XCTestCase {

    let sampleInput = """
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        """

    func testCommandRegex() {
        let console = ElfConsole(output: "")
        var answer = "$ cd /".firstMatch(of: console.commandRegex)
        XCTAssertNotNil(answer)

        answer = "$ ls".firstMatch(of: console.commandRegex)
        XCTAssertNotNil(answer)

        answer = "dir foo".firstMatch(of: console.commandRegex)
        XCTAssertNil(answer)

        answer = "1234 bar".firstMatch(of: console.commandRegex)
        XCTAssertNil(answer)
    }

    func testDirectoryRegex() {
        let console = ElfConsole(output: "")

        var answer = "dir foo".firstMatch(of: console.directoryRegex)
        XCTAssertNotNil(answer)

        answer = "$ cd /".firstMatch(of: console.directoryRegex)
        XCTAssertNil(answer)

        answer = "1234 bar".firstMatch(of: console.directoryRegex)
        XCTAssertNil(answer)
    }

    func testFileRegex() {
        let console = ElfConsole(output: "")

        var answer = "1234 bar".firstMatch(of: console.fileRegex)
        XCTAssertNotNil(answer)

        answer = "$ cd /".firstMatch(of: console.fileRegex)
        XCTAssertNil(answer)

        answer = "dir foo".firstMatch(of: console.fileRegex)
        XCTAssertNil(answer)
    }

    func testParsing() {
        let output = """
            $ cd /
            $ ls
            dir a
            14848514 b.txt
            8504156 c.dat
            """

        let console = ElfConsole(output: output)
        let parsedOutput = console.parse()
        XCTAssertEqual(5, parsedOutput.count)

        XCTAssertEqual(.command(name: "cd", options: "/"), parsedOutput[0])
        XCTAssertEqual(.command(name: "ls", options: nil), parsedOutput[1])
        XCTAssertEqual(.directory(name: "a"), parsedOutput[2])
        XCTAssertEqual(.file(name: "b.txt", size: 14848514), parsedOutput[3])
        XCTAssertEqual(.file(name: "c.dat", size: 8504156), parsedOutput[4])
    }

    func testConsoleRun() {
        let console = ElfConsole(output: sampleInput)
        console.run()
        console.printFilesystem()
        // TODO: make this a real test...
    }

    func testSizeCalculations() {
        let console = ElfConsole(output: sampleInput)
        console.run()

        XCTAssertEqual(48381165, console.filesystem.size)

        let aDir = console.filesystem.children.first(where: { $0.name == "a" }) as? FilesystemDirectory
        XCTAssertEqual(94853, aDir?.size)

        let eDir = aDir?.children.first(where: { $0.name == "e" }) as? FilesystemDirectory
        XCTAssertEqual(584, eDir?.size)

        let dDir = console.filesystem.children.first(where: { $0.name == "d" }) as? FilesystemDirectory
        XCTAssertEqual(24933642, dDir?.size)
    }

    func testPartOne() {
        let day = DaySeven2022()
        let answer = day.partOne(input: sampleInput)
        XCTAssertEqual(95437, answer as! Int)
    }
}
