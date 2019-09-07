//
//  ExexUnitExec.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-01.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

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

fileprivate let execColor = Color.blue.opacity(0.4)
fileprivate let readColor = Color.green.opacity(0.4)
fileprivate let writeColor = Color.red.opacity(0.4)

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
        readArrow = ArrowData(memory[addr].tag, "Arithmatic Unit", readColor)
        return memory[addr].value
    }

    func ioOp(_ opcode: OpCode) {
        switch opcode {
        case let .inp(addr):
            let prevHead = inTape.head
            switch inTape.readNext() {
            case let .success(val):
                memory[addr].setValue(val % 999)
                writeAddr = addr
                writeArrow = ArrowData(inTape[prevHead].tag, memory[addr].tag, writeColor)
            case let .failure(err):
                iotrap(err)
            }
        case let .out(addr):
            let prevHead = inTape.head
            switch outTape.writeNext(memory[addr].value) {
            case .success:
                readAddr = addr
                readArrow = ArrowData(memory[addr].tag, outTape[prevHead].tag, readColor)
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
        alu.operation = .nosign
        alu.shiftLeft(left)
        alu.shiftRight(right)
        return
    }

    func execOne(_ doHalt: Bool = false) {
        if doHalt { halt(.stepping) }
        if runState == .halted { runState = .stepping }
        address = next
        next += 1
        readAddr = UInt16.max
        writeAddr = UInt16.max

        clearArrows()
        execArrow = ArrowData(memory[address].tag, "Execution Unit", execColor)

        switch opcode {
        case .inp, .out: ioOp(opcode)
        case .cla, .add, .sub: aluOp(opcode)
        case .tac, .jmp, .hrs: jumpOp(opcode)
        case let .slr(slr): shiftOp(slr/10, slr % 10)
        case let .sto(addr):
            memory[addr].setValue(alu.result.value % 999)
            writeAddr = addr
            writeArrow = ArrowData("Arithmatic Unit", memory[addr].tag, writeColor)
        default: trap(.illegal(opcode))
        }

        memory.setActivity(read: readAddr, write: writeAddr, exec: address)
        if runState == .stepping { runState = .halted }
    }
}
