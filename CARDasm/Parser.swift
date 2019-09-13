//
//  Parser.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func parse(_ indata: String) -> DumpData {
    let dump = DumpData()

    // Add location 00
    let one = Location.get("one")
    one.address = 0
    let tokens = tokenize(indata)

    for token in tokens {
        switch token {
        case let .data(location, value):
            switch location.plus(0) {
            case let .failure(err): print("Error: \(err.localizedDescription)")
            case let .success(address):
                dump.memoryAppend(AddressAndData(address: address, data: Int(value)!))
            }
        case let .error(lineNr, err):
            print("Error on line \(lineNr): \(err.localizedDescription)")
        case .location: break
        case let .opCode(location, opcode):
            switch opcode.generate() {
            case let .failure(err): print("Error: \(err.localizedDescription)")
            case let .success(value):
                switch location.plus(0) {
                case let .failure(err): print("Error: \(err.localizedDescription)")
                case let .success(address):
                    dump.memoryAppend(AddressAndData(address: address, data: value))
                }
            }
        default: print("Unknown token: \(token)")
        }
    }

    return dump
}
