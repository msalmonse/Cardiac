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
    var printDiff = true

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTokenizer() {
        let tokens = tokenize(testInput)
        print(tokens)
        XCTAssertEqual(tokens.count, 17)
    }

    func testParser() {
        func checkDump(_ dump: DumpData) {
            XCTAssertEqual(dump.next, 25)
            XCTAssertEqual(dump.memory.count, 10)
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
                XCTAssertEqual(errList.count, 4)
            default:
                XCTFail("Unexpected error: \(err)")
            }
        }

        switch parse(testInput) {
        case let .success(dump): checkDump(dump)
        case let .failure(err): XCTFail("Unexpected error: \(err)")
        }
    }

    func testOneData() {
        switch oneData(testInput) {
        case let .failure(err): XCTFail("Unexpected error: \(err)")
        case let .success(data):
            XCTAssertEqual(data.count, testJsonSize)
        }
    }

    func testOneFile() {
        let tmpIn = tempDirURL().appendingPathComponent("test.txt")
        do {
            try testInput.write(to: tmpIn, atomically: true, encoding: .utf8)
        } catch {
            XCTFail("Error writing to file: \(error)")
            return
        }

        switch assembleOneFile(tmpIn, to: .notspecified) {
        case let .failure(err): XCTFail("Unexpected error: \(err)")
        case .success: break
        }

        let tmpJson = tempDirURL().appendingPathComponent("test.json")
        do {
            let values = try tmpJson.resourceValues(forKeys: [.fileSizeKey])
            XCTAssertEqual(values.fileSize!, testJsonSize)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        switch disassembleOneFile(tmpJson, to: .notspecified) {
        case let .failure(err): XCTFail("Unexpected error: \(err)")
        case .success: break
        }

        let tmpAsm = tempDirURL().appendingPathComponent("test.cardasm")
        do {
            let values = try tmpAsm.resourceValues(forKeys: [.fileSizeKey])
            XCTAssertEqual(values.fileSize!, testAsmSize)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

    }

    func testDisAssemble() {
        switch parse(testInput) {
        case .failure: XCTAssertFalse(true, "Wrong error")
        case let .success(dump):
            let result = disAssemble(dump)
            if printDiff { print(result.difference(from: testDis)) }
            XCTAssertEqual(result, testDis)
        }
    }

    func testDisAssPerformance() {
        printDiff = false
        measure {
            // Test the time for tokeniser, parser and dissassembler
            for _ in 0...99 { testDisAssemble() }
        }
    }

    func testOneDataPerformance() {
        measure {
            // Test the time for tokeniser, parser and encoder
            for _ in 0...99 { testOneData() }
        }
    }

    func testURL() {
        let paths = [
            "a/b/c",
            "/a/b/c",
            "../a/b/c"
        ]

        for path in paths {
            let url = URL(fileURLWithPath: path)
            print(path, url.path)
        }
    }

}

let badInput = """

# This is a comment

data1: dat 0
data1: dat 1
    dat start

    loc 80
bss0: bss 20

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
bss0: bss 10

label1: loc 23
    inp data1
    slr 3 1     # comment
start: sub data0
    blt start
    sto bss0
    ld data1
    jmp label1

    tape 23
    tape 42

comment

This is a comment

endcomment

"""

let testAsmSize = 224
let testJsonSize = 284

let testComment = """

This is a comment

"""

let testDis = """
   loc 3
loc03: data 0
loc04: data 1
   inp start # 25
   loc 23
loc23: inp loc04 # 4
   slr 3 1 # 431
start: sub loc03 # 703
   sto loc06 # 606
   jmp loc23 # 823
   tape 23
   tape 42
comment

This is a comment

endcomment
"""
