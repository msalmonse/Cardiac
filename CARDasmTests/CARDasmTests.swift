//
//  CARDasmTests.swift
//  CARDasmTests
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import XCTest
// @testable import CARDasm

class CARDasmTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTokenizer() {
        let tokens = tokenize(testInput)
        print(tokens)
        XCTAssertEqual(tokens.count, 12)
    }

    func testParser() {
        func checkDump(_ dump: DumpData) {
            XCTAssertEqual(dump.next, 25)
            XCTAssertEqual(dump.memory.count, 7)
            XCTAssertNotNil(dump.input)
            XCTAssertEqual(dump.input?.count, 2)
            XCTAssertNotNil(dump.comment)
            XCTAssertEqual(dump.comment?.count, 3)
            XCTAssertEqual(dump.comment?.joined(separator: "\n"), testComment)
        }

        switch parse(badInput) {
        case .success: XCTAssertFalse(true)
        case let .failure(err):
            switch err {
            case let ParserError.errorsExist(errList):
                XCTAssertEqual(errList.count, 3)
            default:
                XCTAssertFalse(true, "Wrong error")
            }
        }

        switch parse(testInput) {
        case let .success(dump): checkDump(dump)
        case .failure: XCTAssertFalse(true, "Wrong error")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

let badInput = """

# This is a comment

data1: dat 0
data1: dat 1
    dat start

label1: loc 23
    inp data1
    slr 3 1     # comment
    sub one
    jmp label1

    tape 1001
    tape 42
"""

let testInput = """

# This is a comment

data0: dat 0
data1: dat 1
    dat start

label1: loc 23
    inp data1
    slr 3 1     # comment
start: sub one
    jmp label1

    tape 23
    tape 42

comment

This is a comment

endcomment

"""

let testComment = """

This is a comment

"""
