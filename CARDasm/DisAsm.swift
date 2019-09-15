//
//  DisAsm.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-14.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

let opCodeName = [
    "inp",
    "cla",
    "add",
    "tac",
    "slr",
    "out",
    "sto",
    "sub",
    "jmp",
    "hrs"
]

enum DestinationType {
    case data(String)
    case instruction(String)
}

typealias Destinations = [Int: DestinationType]

fileprivate func memPass1(_ dump: DumpData) -> Destinations {
    var destinations: Destinations = [:]

    destinations[dump.next] = .instruction("start")
    destinations[0] = .data("one")

    for mem in dump.memory {
        switch oneCell(mem) {
        case let .success(addrData):
            let data = addrData.data
            let addr = data % 100
            let label = String(format: "loc%02d", addr)
            switch data/100 {
                // slr
            case 4: break
                // jump instructions
            case 3, 8, 9: if destinations[addr] == nil { destinations[addr] = .instruction(label) }
            default: if destinations[addr] == nil { destinations[addr] = .data(label) }
            }
        case .failure: break
        }
    }
    return destinations
}

fileprivate func labelAdjust(_ label: String) -> String {
    return label != "  " ? label + ":" : label
}

fileprivate func dataDest(_ label: String, _ data: Int) -> String {
    return "\(labelAdjust(label)) data \(data)"
}

fileprivate func instructionDest(
    _ label: String,
    _ data: Int,
    _ destinations: Destinations
) -> String {
    let opVal = data/100
    let oper = opVal < opCodeName.count ? opCodeName[opVal] : "???"
    if oper == "slr" {
        return "\(labelAdjust(label)) slr \((data/10) % 10) \(data % 10) # \(data)"
    } else {
        var destLabel: String
        switch destinations[ data % 100 ] {
        case let .data(label): destLabel = label
        case let .instruction(label): destLabel = label
        default: destLabel = String(format: "%03d", data)
        }
        return "\(labelAdjust(label)) \(oper) \(destLabel) # \(data)"
    }
}

fileprivate func memPhase2(_ dump: DumpData, _ destinations: Destinations) -> [String] {
    var lines = [String]()
    var address = 0

    for mem in dump.memory {
        switch oneCell(mem) {
        case let .success(addrData):
            let addr = addrData.address
            let data = addrData.data
            if address != addr {
                lines.append("   loc \(addr)")
                address = addr
            }
            let dest = destinations[address] ?? .instruction("  ")
            switch dest {
            case let .data(label):
                lines.append(dataDest(label, data))
            case let .instruction(label):
                lines.append(instructionDest(label, data, destinations))
            }
        case .failure: break
        }
        address += 1
    }
    return lines
}

func disAssemble(_ dump: DumpData) -> String {
    let destinations = memPass1(dump)
    var lines = memPhase2(dump, destinations)

    for tape in dump.input ?? [] {
        switch oneCell(tape) {
        case let .success(addrData):
            let data = addrData.data
            lines.append("   tape \(data)")
        case .failure: break
        }
    }

    if dump.comment != nil {
        lines.append("comment")
        lines.append(contentsOf: dump.comment!)
        lines.append("endcomment")
    }

    return lines.joined(separator: "\n")
}
