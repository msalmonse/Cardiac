//
//  Parser.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation

enum ParserError: Error {
    case errorsExist([Error])
}

enum ParsedElements {
    case comment(String)        // comment
    case data(Int, Int)         // location and data
    case instruction(Int, Int)  // location and instruction
    case start(Int)             // program start
    case tape(Int)              // data on tape
}

typealias Program = [ParsedElements]

func locationInitialize() {
    // Remove any previous parse data
    Location.clear()

    // Add location 00
    let one = Location.get("one")
    one.address = 0
    // Add location 99, return jump
    let ninety9 = Location.get("return")
    ninety9.address = 99
}

func parse(_ indata: String) -> Result<Program, Error> {
    var program = Program()
    var errors = [Error]()
    var commentLines = [String]()
    var startFound = false

    func errPrint(_ lineNr: Int, _ err: Error) {
        print("Error on line \(lineNr): \(err.localizedDescription)")
        errors.append(err)
    }

    locationInitialize()

    let tokens = tokenize(indata)

    // check for start label
    let start = Location.get("start")
    if let startAddress = start.address {
        program.append(.start(startAddress))
        startFound = true
    }

    for token in tokens {
        switch token {
        case let .comment(line): commentLines.append(line)
        case let .data(lineNr, location, value):
            switch location.plus(0) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(address):
                switch dataValue(Substring(value)) {
                case let .failure(err): errPrint(lineNr, err)
                case let .success(data):
                    program.append(.data(address, data))
                }
            }
        case let .error(lineNr, err): errPrint(lineNr, err)
        case .location: break
        case let .opCode(lineNr, location, opcode):
            switch opcode.generate() {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(inst):
                switch location.plus(0) {
                case let .failure(err): errPrint(lineNr, err)
                case let .success(address):
                    if !startFound {
                        program.append(.start(address))   // start at first instruction
                        startFound = true
                    }
                    program.append(.instruction(address, inst))
                }
            }
        case let .tape(lineNr, value):
            switch dataValue(Substring(value)) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(data):
                program.append(.tape(data))
            }
        }
    }

    return errors.count == 0 ? .success(program) : .failure(ParserError.errorsExist(errors))
}
