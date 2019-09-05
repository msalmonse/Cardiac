//
//  ExexUnitExec.swift
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

extension ExecUnit {

    func trap(_ reason: ExecError) {
        print("Trap @\(address): " + (reason.errorDescription ?? "Unknown"))
        halt()
        return
    }

    func iotrap(_ reason: TapeError) {
        print("IOtrap @\(address): " + (reason.errorDescription ?? "Unknown"))
        next = address     // Instruction not completed
        if reason == TapeError.endOfTape { halt(.iowait) }
        halt()
        return
    }

    func opB(_ addr: UInt16) -> UInt16 {
        readAddr = addr
        return memory[addr].value
    }

    func ioOp(_ opcode: OpCode) {
        switch opcode {
        case let .inp(addr):
            switch inTape.readNext() {
            case let .success(val):
                memory[addr].setValue(val % 999)
                writeAddr = addr
            case let .failure(err):
                iotrap(err)
            }
        case let .out(addr):
            switch outTape.writeNext(memory[addr].value) {
            case .success:
                readAddr = addr
            case let .failure(err):
                iotrap(err)
            }
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
        case let .tac(addr):
            if alu.isNegative {
                next = addr
                writeAddr = 99
            }
        case let .jmp(addr):
            next = addr
            writeAddr = 99
        case let .hrs(addr):
            next = addr
            halt()
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
        if runState == .halted { runState = .stepping }
        address = next
        next += 1
        readAddr = UInt16.max
        writeAddr = UInt16.max
        let opcode = self.opcode    // local cache

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

        memory.setActivity(read: readAddr, write: writeAddr, exec: address)
        if runState == .stepping { runState = .halted }
    }
}
