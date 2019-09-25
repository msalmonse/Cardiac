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

enum MemoryElements {
    case data(Int, Int)         // location and data
    case instruction(Int, Int)  // location and instruction
}

class Program {
    var commentLines = [String]()
    var memory = [MemoryElements]()
    var input = [Int]()
    var start = -1
}

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

    func errPrint(_ lineNr: Int, _ err: Error) {
        print("Error on line \(lineNr): \(err.localizedDescription)")
        errors.append(err)
    }

    locationInitialize()

    let tokens = tokenize(indata)

    // check for start label
    let start = Location.get("start")
    if let startAddress = start.address { program.start = startAddress }

    for token in tokens {
        switch token {
        case let .comment(line): program.commentLines.append(line)
        case let .data(lineNr, location, value):
            switch location.plus(0) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(address):
                switch dataValue(Substring(value)) {
                case let .failure(err): errPrint(lineNr, err)
                case let .success(data):
                    program.memory.append(.data(address, data))
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
                    // start at first instruction
                    if program.start < 0 { program.start = address }
                    program.memory.append(.instruction(address, inst))
                }
            }
        case let .tape(lineNr, value):
            switch dataValue(Substring(value)) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(data): program.input.append(data)
            }
        }
    }

    return errors.count == 0 ? .success(program) : .failure(ParserError.errorsExist(errors))
}
