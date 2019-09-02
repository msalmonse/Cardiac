//
//  Instruction.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation

enum OpCode {
    case inp(UInt16)
    case cla(UInt16)
    case add(UInt16)
    case tac(UInt16)
    case slr(UInt16)
    case out(UInt16)
    case sto(UInt16)
    case sub(UInt16)
    case jmp(UInt16)
    case hrs(UInt16)
    case unk(UInt16)

    static func opcode(_ val: UInt16, _ extra: UInt16) -> OpCode {
        switch val {
        case 0: return .inp(extra)
        case 1: return .cla(extra)
        case 2: return .add(extra)
        case 3: return .tac(extra)
        case 4: return .slr(extra)
        case 5: return .out(extra)
        case 6: return .sto(extra)
        case 7: return .sub(extra)
        case 8: return .jmp(extra)
        case 9: return .hrs(extra)
        default: return .unk(val)
        }
    }

    var value: UInt16 {
        switch self {
        case .inp: return 0
        case .cla: return 1
        case .add: return 2
        case .tac: return 3
        case .slr: return 4
        case .out: return 5
        case .sto: return 6
        case .sub: return 7
        case .jmp: return 8
        case .hrs: return 9
        case let .unk(val): return val
        }
    }
}

/// Convert a cell's opcode and address into a string

func instruction(_ cell: Cell, verbose: Bool = true) -> String {
    return instruction(cell.opcode, verbose: verbose)
}

func instruction(_ opcode: OpCode, verbose: Bool = false) -> String {
    func sl(_ val: UInt16) -> UInt16 { return val / 10 }
    func sr(_ val: UInt16) -> UInt16 { return val % 10 }
    func fmt(_ addr: UInt16) -> String { return String(format: "%02d", Int(addr)) }

    switch (opcode, verbose) {
    case (let .inp(addr), true):  return "Read from tape to " + fmt(addr)
    case (let .inp(addr), false): return "INP " + fmt(addr)
    case (let .cla(addr), true):  return "Load from " + fmt(addr)
    case (let .cla(addr), false): return "CLA " + fmt(addr)
    case (let .add(addr), true):  return "Add " + fmt(addr)
    case (let .add(addr), false): return "ADD " + fmt(addr)
    case (let .tac(addr), true):  return "Jump if -ve to " + fmt(addr)
    case (let .tac(addr), false): return "TAC " + fmt(addr)
    case (let .slr(addr), true):  return "Shift left \(sl(addr)), right\(sr(addr))"
    case (let .slr(addr), false): return "SL\(sl(addr)) SR\(sr(addr))"
    case (let .out(addr), true):  return "Write from \(addr) to tape"
    case (let .out(addr), false): return "OUT " + fmt(addr)
    case (let .sto(addr), true):  return "Store to " + fmt(addr)
    case (let .sto(addr), false): return "STO " + fmt(addr)
    case (let .sub(addr), true):  return "Subtract " + fmt(addr)
    case (let .sub(addr), false): return "SUB " + fmt(addr)
    case (let .jmp(addr), true):  return "Jump to " + fmt(addr)
    case (let .jmp(addr), false): return "JMP " + fmt(addr)
    case (let .hrs(addr), true):  return "Halt and reset to " + fmt(addr)
    case (let .hrs(addr), false): return "HRS " + fmt(addr)
    case (let .unk(val), true):  return "Unkown opcode \(val)"
    case (let .unk(val), false): return "UNK \(val)"
    }
}
