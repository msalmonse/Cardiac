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

fileprivate func tableBuild() -> [Int] {
    var table: [Int] = []
    for outer in char32 {
        for inner in char32 {
            table.append(Int(outer << 8 | inner))
        }
    }
    return table
}

fileprivate func inverseTableBuild() -> [Int: Int] {
    let table = tableBuild()
    var inverse: [Int: Int] = [:]

    for index in table.indices {
        inverse[table[index]] = index
    }

    return inverse
}

class Base32Encoder {
    static var table: [Int] = tableBuild()

    func octets(_ in1: Int, _ in2: Int = Int.max) -> [UInt8] {
        var ret: [UInt8] = []

        func one(_ indata: Int) {
            let encoded = self[Int(indata)]
            ret.append(UInt8(encoded >> 8 & 0xff))
            ret.append(UInt8(encoded & 0xff))
        }

        one(in1)
        if in2 < Self.table.count { one(in2) }

        return ret
    }

    func octets(_ addrData: AddressAndData) -> [UInt8] {
        return self.octets(addrData.address, addrData.data)
    }

    subscript(index: Int) -> Int {
        return Self.table.indices.contains(index) ? Self.table[index] : query2
    }
}

class Base32Decoder {
    static var table: [Int: Int] = inverseTableBuild()

    // Lookup the result of 2 octets
    func hextet(_ in1: UInt8, _ in2: UInt8) -> Int {
        return self[Int(in1) << 8 | Int(in2)]
    }

    // Remove 2 octets from the data array and return their decoded value
    func hextet(_ data: inout Data) -> Int {
        // First check for eof marker
        if data.count < 2 || data.first == 0x7e { return self[0x7e0a] }
        guard let val1 = data.popFirst(), let val2 = data.popFirst() else { return self[0x7e0a] }
        return hextet(val1, val2)
    }

    subscript(index: Int) -> Int {
        return Self.table[index] ?? Int(UInt16.max)
    }
}
