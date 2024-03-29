//
//  ExexUnitExec.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-01.
//  Copyright © 2019 mesme. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity

import SwiftUI

enum ExecError: Error {
    case illegal(Operation)    // Illegal operation
    case invalid(UInt16)    // Invalid operation
    case badNumber          // failure during conversion
    case outOfRange
    case readB4Write(UInt16)
}

extension ExecError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badNumber: return "Not a number"
        case let .illegal(operation): return "Illegal operation: \(operation.value)"
        case let .invalid(value): return "Invalid operation: \(value)"
        case .outOfRange: return "Out of range"
        case let .readB4Write(addr): return "Read of address \(addr) before write"
        }
    }
}

fileprivate let execColor = Color.blue.opacity(0.4)
fileprivate let readColor = Color.green.opacity(0.4)
fileprivate let writeColor = Color.red.opacity(0.4)

extension ExecUnit {

    func trap(_ reason: ExecError) {
        let message = errorMessage(reason, "Trap @\(address)")
        MessagePublisher.publish(.error(message))
        halt()
        return
    }

    func iotrap(_ reason: TapeError) {
        let message = errorMessage(reason, "IO Trap @\(address)")
        MessagePublisher.publish(.error(message))
        next = address     // Instruction not completed
        if reason == TapeError.endOfTape { halt(.iowait) }
        halt(.iowait)
        return
    }

    func opB(_ addr: UInt16) -> UInt16 {
        if !memory[addr].valid { trap(.readB4Write(addr)) }
        readAddr = addr
        readArrow = generateArrow(memory[addr].tag, "Arithmatic Unit", readColor)
        return memory[addr].value
    }

    func ioOp(_ operation: Operation) {
        switch operation {
        case let .inp(addr):
            switch inTape.readNext() {
            case let .success(val):
                memory[addr].setValue(val % 999)
                writeAddr = addr
                writeArrow = generateArrow("Input", memory[addr].tag, writeColor)
            case let .failure(err):
                iotrap(err)
            }
        case let .out(addr):
            if !memory[addr].valid { trap(.readB4Write(addr)) }
            switch outTape.writeNext(memory[addr].value) {
            case .success:
                readAddr = addr
                readArrow = generateArrow(memory[addr].tag, "Output", readColor)
            case let .failure(err):
                iotrap(err)
            }
        default: trap(.illegal(operation))
        }
        return
    }

    func aluOp(_ operation: Operation) {
        switch operation {
        case let .cla(addr): alu.cla(opB(addr))
        case let .add(addr): alu.add(opB(addr))
        case let .sub(addr): alu.sub(opB(addr))
        default: trap(.illegal(operation))
        }
        return
    }

    func jumpOp(_ operation: Operation) {
        switch operation {
        case let .tac(addr):
            if alu.isNegative { next = addr }
        case let .jmp(addr):
            writeAddr = 99
            writeArrow = generateArrow("Execution Unit", memory[99].tag, writeColor)
            memory[99].setRW().setValue(800 + next).setRO()
            next = addr
        case let .hrs(addr):
            next = addr
            clearArrows()
            halt()
        default: trap(.illegal(operation))
        }
        return
    }

    func shiftOp(_ left: UInt16, _ right: UInt16) {
        alu.operation = .nosign
        alu.shiftLeft(left)
        alu.shiftRight(right)
        return
    }

    func storeOp(_ addr: UInt16) {
        memory[addr].setValue(alu.result.value % 999)
        writeAddr = addr
        writeArrow = generateArrow("Arithmatic Unit", memory[addr].tag, writeColor)
    }

    func execOne(_ doHalt: Bool = false) {
        if doHalt { halt(.stepping) }
        if runState == .halted { runState = .stepping }

        address = next
        if runState != .stepping && breakPointCheck() {
            halt()
            return
        }

        next += 1
        readAddr = UInt16.max
        writeAddr = UInt16.max

        clearArrows()
        execArrow = generateArrow(memory[address].tag, "Execution Unit", execColor)

        switch operation {
        case .inp, .out: ioOp(operation)
        case .cla, .add, .sub: aluOp(operation)
        case .tac, .jmp, .hrs: jumpOp(operation)
        case let .slr(slr): shiftOp(slr/10, slr % 10)
        case let .sto(addr): storeOp(addr)
        case let .inv(value): trap(.invalid(value))
        default: trap(.illegal(operation))
        }

        memory.setActivity(read: readAddr, write: writeAddr, exec: address)
        if runState == .stepping { runState = .halted }
    }
}
