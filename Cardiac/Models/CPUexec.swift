//
//  CPUexec.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-01.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

enum ExecError: Error {
    case illegal(OpCode)    // Illegal opcode
}

extension ExecError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .illegal(opcode): return "Illegal opcode: \(opcode.value)"
        }
    }
}

extension CPU {

    func trap(_ reason: ExecError) {
        print("Trap @\(execAddr): " + (reason.errorDescription ?? "Unknown"))
        halt()
        return
    }

    func halt() {
        return
    }

    func opB(_ addr: UInt16) -> UInt16 {
        readAddr = addr
        return memory[addr].value
    }

    func ioOp(_ opcode: OpCode) {
        switch opcode {
        default: trap(.illegal(opcode))
        }
        return
    }

    func aluOp(_ opcode: OpCode) {
        switch opcode {
        case let .cla(addr): alu.cla(opB(addr))
        case let .add(addr): alu.add(opB(addr))
        case let .sub(addr): alu.sub(opB(addr))
        default: trap(.illegal(opcode))
        }
        return
    }

    func jumpOp(_ opcode: OpCode) {
        switch opcode {
        case let .tac(addr): if alu.isNegative { execNext = addr }
        case let .jmp(addr): execNext = addr
        case let .hrs(addr): execNext = addr; halt()
        default: trap(.illegal(opcode))
        }
        return
    }

    func shiftOp(_ left: UInt16, _ right: UInt16) {
        alu.shiftLeft(left)
        alu.shiftRight(right)
        return
    }

    func execOne() {
        execAddr = execNext
        execNext += 1
        readAddr = UInt16.max
        writeAddr = UInt16.max

        let opcode = memory[execAddr].opcode

        switch opcode {
        case .inp, .out: ioOp(opcode)
        case .cla, .add, .sub: aluOp(opcode)
        case .tac, .jmp, .hrs: jumpOp(opcode)
        case let .slr(slr): shiftOp(slr/10, slr % 10)
        case let .sto(addr):
            memory[addr].setValue(alu.result.value % 999)
            writeAddr = addr
        default: trap(.illegal(opcode))
        }

        memory.setActivity(read: readAddr, write: writeAddr, exec: execAddr)
    }
}
