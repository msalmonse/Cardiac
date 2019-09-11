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
        XCTAssertEqual(tokens.count, 6)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

let testInput = """

# This is a comment

data1: dat 0
data1: dat 1

label1: loc 23
    inp data1
    slr 3 1
    jmp label1

"""
