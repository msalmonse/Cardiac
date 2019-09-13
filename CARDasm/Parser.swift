//
//  Parser.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import Foundation

func parse(_ indata: String) -> DumpData {
    let dump = DumpData()

    // Add location 00
    let one = Location.get("one")
    one.address = 0
    let tokens = tokenize(indata)

    // check for start label
    let start = Location.get("start")
    if let startAddress = start.address {
        dump.next = startAddress
    }

    for token in tokens {
        switch token {
        case let .comment(line): dump.commentAppend(line)
        case let .data(location, value):
            switch location.plus(0) {
            case let .failure(err): print("Error: \(err.localizedDescription)")
            case let .success(address):
                switch dataValue(Substring(value)) {
                case let .failure(err): print("Error: \(err.localizedDescription)")
                case let .success(data):
                    dump.memoryAppend(AddressAndData(address: address, data: data))
                }
            }
        case let .error(lineNr, err):
            print("Error on line \(lineNr): \(err.localizedDescription)")
        case .location: break
        case let .opCode(location, opcode):
            switch opcode.generate() {
            case let .failure(err): print("Error: \(err.localizedDescription)")
            case let .success(data):
                switch location.plus(0) {
                case let .failure(err): print("Error: \(err.localizedDescription)")
                case let .success(address):
                    if dump.next == 0 { dump.next = address }   // start at first instruction
                    dump.memoryAppend(AddressAndData(address: address, data: data))
                }
            }
        case let .tape(value): dump.inputAppend(Int(value)!)
        }
    }

    return dump
}
