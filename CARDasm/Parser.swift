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
            dump.memoryAppend(location.address!, Int(value)!)
        default: print("Unknown token: \(token)")
        }
    }

    return dump
}
