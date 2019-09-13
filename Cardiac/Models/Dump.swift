//
//  Dump.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

/// Memory and Input iare stored as a dict with keys of "addr" and "data"

struct AddressAndData {
    let address: Int
    let data: Int
}

// Class used to load data from JSON dump and during assembly

class DumpData: Codable {
    var next = 0                            // next address to execute
    var memory = [[String: Int]]()          // memory contents as a dict
    var input: [[String: Int]]? = nil       // optional input as dict
    var comment: [String]? = nil            // optional comment, an array of one string per line

    enum CodingKeys: String, CodingKey {
        case next = "PC"
        case memory
        case input
        case comment
    }

    func memoryAppend(_ indata: AddressAndData) {
        let addrAndData: [String:Int] = [ "addr": indata.address, "data": indata.data ]
        memory.append(addrAndData)
    }

    func inputAppend(_ data: Int) {
        if input == nil { input = [[String: Int]]() }
        let addrAndData: [String:Int] = [ "addr": input!.count, "data": data ]
        input!.append(addrAndData)
    }

    func commentAppend(_ line: String) {
        if comment == nil { comment = [String]() }
        comment!.append(line)
    }
}
