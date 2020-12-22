//
//  DayTwentyTests.swift
//  Test
//
//  Created by Shawn Veader on 12/20/20.
//

import XCTest

class DayTwentyTests: XCTestCase {

    func testSatImageTileParsing() {
        let image = SatelliteImage(testInput)
        XCTAssertEqual(9, image.tiles.count)

        let tile = image.tiles[2311]
        XCTAssertEqual(2311, tile?.tileID)
    }

    func testSatImageTileEdges() {
        let image = SatelliteImage(testInput)
        let tile = image.tiles[2311]!
        let edges = tile.edges()
        XCTAssertNotNil(edges)
        XCTAssertEqual("..##.#..#.", edges!.topString)
        XCTAssertEqual("...#.##..#", edges!.rightString)
        XCTAssertEqual("..###..###", edges!.bottomString)
        XCTAssertEqual(".#..#####.", edges!.leftString)
    }

    func testSatImageTileEdgeMatch() {
        let image = SatelliteImage(testInput)
        let leftTopCornerTile = image.tiles[1951]!
        let topMidTile = image.tiles[2311]!
        let rightTopCornerTile = image.tiles[3079]!
        let leftMidTile = image.tiles[2729]!
        XCTAssertTrue(leftTopCornerTile.aligns(with: topMidTile))
        XCTAssertTrue(leftTopCornerTile.aligns(with: leftMidTile))
        XCTAssertFalse(leftTopCornerTile.aligns(with: rightTopCornerTile))
    }

    func testSatImageTileAlignmentMapping() {
        let image = SatelliteImage(testInput)
        image.mapTiles()
        let alignments = image.tileAlignments
        XCTAssertEqual(image.tiles.count, alignments.count)
        XCTAssertTrue(alignments[1951]!.contains(2311))
        XCTAssertTrue(alignments[1951]!.contains(2729))
    }

    func testSatImageCorners() {
        let image = SatelliteImage(testInput)
        let corners = image.findCorners()
        XCTAssertEqual(4, corners.count)
        XCTAssertEqual(20899048083289, corners.reduce(1, *))
    }

    let testInput = """
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...
    """
}
