//
//  Base32.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-19.
//  Copyright © 2019 mesme. All rights reserved.
//

// Convert a UInt16 in the range 0..<1000 to a two character string encoded in a UInt16

import Foundation

// The characters used for encoding
fileprivate let string32 = "0123456789ABCDEFHJKLMNPRSTUVWXYZ"
// The unicode values of the above string
fileprivate let char32 = string32.unicodeScalars.map { $0.value }
// The value for ??
fileprivate let query2 = 0x3f3f

class Base32Encoder {
    var table: [Int] = []
    init() {
        // Build the table
        for outer in char32 {
            for inner in char32 {
                table.append(Int(outer << 8 | inner))
            }
        }
    }

    subscript(index: Int) -> Int {
        return table.indices.contains(index) ? table[index] : query2
    }
}

class Base32Decoder {
    var table: [Int: Int] = [:]

    init() {
        let encoder = Base32Encoder()

        for value in 0..<1000 {
            table[encoder[value]] = value
        }
        table[query2] = Int(UInt16.max)
    }

    subscript(index: Int) -> Int {
        return table[index] ?? Int(UInt16.max)
    }
}
