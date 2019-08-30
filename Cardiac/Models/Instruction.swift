//
//  Instruction.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

/// Convert a cell's opcode and address into a string

// swiftlint:disable cyclomatic_complexity

func instruction(_ cell: Cell, verbose: Bool = true) -> String {
    func sl() -> UInt16 { return cell.address / 10 }
    func sr() -> UInt16 { return cell.address % 10 }

    let opcode = cell.opcode
    let addr = String(format: "%02d", cell.address)

    switch (opcode, verbose) {
    case (0, true):  return "Read from tape to " + addr
    case (0, false): return "INP " + addr
    case (1, true):  return "Load from " + addr
    case (1, false): return "CLA " + addr
    case (2, true):  return "Add " + addr
    case (2, false): return "ADD " + addr
    case (3, true):  return "Jump if -ve to " + addr
    case (3, false): return "TAC " + addr
    case (4, true):  return "Shift left \(sl()), right\(sr())"
    case (4, false): return "SL\(sl()) SR\(sr())"
    case (5, true):  return "Write from \(addr) to tape"
    case (5, false): return "OUT " + addr
    case (6, true):  return "Store to " + addr
    case (6, false): return "STO " + addr
    case (7, true):  return "Subtract " + addr
    case (7, false): return "SUB " + addr
    case (8, true):  return "Jump to " + addr
    case (8, false): return "JMP " + addr
    case (9, true):  return "Halt and reset to " + addr
    case (9, false): return "HRS " + addr
    case (_, true):  return "Unkown opcode: \(opcode)"
    case (_, false): return "UNK"
    }
}
