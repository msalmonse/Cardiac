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
        let addrAndData: [String: Int] = [ "addr": indata.address, "data": indata.data ]
        memory.append(addrAndData)
    }

    func inputAppend(_ data: Int) {
        if input == nil { input = [[String: Int]]() }
        let addrAndData: [String: Int] = [ "addr": input!.count, "data": data ]
        input!.append(addrAndData)
    }

    func commentAppend(_ line: String) {
        if comment == nil { comment = [String]() }
        comment!.append(line)
    }
}

func oneCell(_ indata: [String: Int]) -> Result<AddressAndData, Error> {
    let addr = indata["addr"]
    let data = indata["data"]
    if addr == nil || data == nil {
        return .failure(FileError.dataFormatError)
    }
    return .success(AddressAndData(address: addr!, data: data!))
}

func loadFromTape(_ url: URL) -> Result<DumpData, Error> {
    var data: Data
    let dump = DumpData()

    do {
        data = try Data(contentsOf: url)
    } catch {
        return .failure(error)
    }

    let decoder = Base32Decoder()

    // Check for bootstrap loaded
    if data.count < 4 || decoder.hextet(&data) != 2 || decoder.hextet(&data) != 800 {
        return .failure(FileError.dataFormatError)
    }

    while data.count > 0 {
        let addr = decoder.hextet(&data)
        // Check to see that addr is an address
        if addr < 100 {
            let memData = decoder.hextet(&data)
            if memData > 999 { return .failure(FileError.dataFormatError) }
            dump.memory.append(["addr": addr, "data": memData])
        } else if addr >= 900 && addr < 999 {
            // It was an hrs so set next and exit loop
            dump.next = addr % 100
            break
        } else {
            return .failure(FileError.dataFormatError)
        }
    }

    if data.count > 2 && data.first != 0x7e {
        dump.input = [[String: Int]]()
        var addr = 0
        while data.count > 0 {
            let tapeData = decoder.hextet(&data)
            // Test for eof
            if tapeData > 999 { break }
            dump.input!.append(["addr": addr, "data": tapeData])
            addr += 1
        }
    }

    if data.count > 2 {
        if data.first != 0x7e { return .failure(FileError.dataFormatError) }
        data = data.dropFirst(2).dropLast(1)   // Skip over comment prefix and trailin newline
        let comment = String(decoding: data, as: UTF8.self)
        dump.comment =
            comment.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
    }

    return .success(dump)
}

func parsedDump(_ indata: String) -> Result<DumpData, Error> {
    let dump = DumpData()

    switch parse(indata) {
    case let .failure(err): return .failure(err)
    case let .success(program):
        dump.next = program.start

        for line in program.commentLines {
            dump.commentAppend(line)
        }

        for element in program.memory {
            switch element {
            case let .data(addr, data), let .instruction(addr, data):
                dump.memoryAppend(AddressAndData(address: addr, data: data))
            }
        }

        for data in program.input {
            dump.inputAppend(data)
        }
    }

    return .success(dump)
}
