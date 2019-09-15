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

func parse(_ indata: String) -> Result<DumpData, Error> {
    let dump = DumpData()
    var errors = [Error]()

    func errPrint(_ lineNr: Int, _ err: Error) {
        print("Error on line \(lineNr): \(err.localizedDescription)")
        errors.append(err)
    }

    locationInitialize()

    let tokens = tokenize(indata)

    // check for start label
    let start = Location.get("start")
    if let startAddress = start.address {
        dump.next = startAddress
    }

    for token in tokens {
        switch token {
        case let .comment(line): dump.commentAppend(line)
        case let .data(lineNr, location, value):
            switch location.plus(0) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(address):
                switch dataValue(Substring(value)) {
                case let .failure(err): errPrint(lineNr, err)
                case let .success(data):
                    dump.memoryAppend(AddressAndData(address: address, data: data))
                }
            }
        case let .error(lineNr, err): errPrint(lineNr, err)
        case .location: break
        case let .opCode(lineNr, location, opcode):
            switch opcode.generate() {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(data):
                switch location.plus(0) {
                case let .failure(err): errPrint(lineNr, err)
                case let .success(address):
                    if dump.next == 0 { dump.next = address }   // start at first instruction
                    dump.memoryAppend(AddressAndData(address: address, data: data))
                }
            }
        case let .tape(lineNr, value):
            switch dataValue(Substring(value)) {
            case let .failure(err): errPrint(lineNr, err)
            case let .success(data):
                dump.inputAppend(data)
            }
        }
    }

    return errors.count == 0 ? .success(dump) : .failure(ParserError.errorsExist(errors))
}
