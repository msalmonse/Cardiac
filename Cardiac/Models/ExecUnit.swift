//
//  ExecUnit.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import Combine
import SwiftUI

enum RunState {
    case running(Double), stepping, halted, iowait, loading

    var description: String {
        switch self {
        case .halted: return "Halted"
        case .iowait: return "Waiting for IO"
        case .loading: return "Loading"
        case let .running(pace): return "Run @\(String(format: "%.1f ips", 60/pace))"
        default: return "Executing"
        }
    }

    static func == (lhs: RunState, rhs: RunState) -> Bool {
        switch (lhs, rhs) {
        case (.halted, .halted): return true
        case (.iowait, .iowait): return true
        case (.loading, .loading): return true
        case (let .running(lhsVal), let .running(rhsVal)):
            if lhsVal == rhsVal { return true }
            return (lhsVal == 0.0 || rhsVal == 0.0)
        case (.stepping, .stepping): return true
        default: return false
        }
    }

    static func != (lhs: RunState, rhs: RunState) -> Bool {
        return !(lhs == rhs)
    }
}

class ExecUnit: ObservableObject, Identifiable {
    //let id = UUID()

    @Published
    var intAddress = 0
    var address: UInt16 = 0 {
        willSet { intAddress = Int(newValue) }
        didSet {
            opcode = memory[address].opcode
            breakPoint = BreakPoint[memory[address].tag]
        }
    }
    var next: UInt16 = 0

    var clock: AnyCancellable? = nil

    @Published
    var runDescription = ""
    var runState: RunState { willSet { runDescription = newValue.description } }

    @Published
    var comment = Comment()

    let alu = ALU()
    let memory: Memory
    let inTape: Tape
    let outTape: Tape

    var readAddr: UInt16 = 0
    var writeAddr: UInt16 = 0

    var opcode: OpCode = .unk(0)
    var breakPoint = BreakOn.never

    // Arrows
    var showArrows: Bool = true {
        willSet {
            if !newValue { clearArrows() }
            objectWillChange.send()
        }
    }

    var execArrow: ArrowData? = nil
    var readArrow: ArrowData? = nil
    var writeArrow: ArrowData? = nil

    func clearArrows() {
        execArrow = nil
        readArrow = nil
        writeArrow = nil
    }

    func generateArrow(_ start: String, _ stop: String, _ color: Color) -> ArrowData? {
        return showArrows ? ArrowData(start, stop, color) : nil
    }

    @discardableResult
    func tryPC(_ tryNext: String) -> Bool {
        guard let tryValue = UInt16(tryNext) else { return false }
        if !(1...98).contains(tryValue) { return false }
        next = tryValue
        return true
    }

    func breakPointCheck() -> Bool {
        switch breakPoint {
        case .never: return false
        case .execute: return true
        default: break
        }

        switch opcode {
        case let .inp(addr), let .sto(addr):
            return BreakPoint[memory[addr].tag] == .write
        case let .out(addr), let .cla(addr), let .add(addr), let .sub(addr):
            return BreakPoint[memory[addr].tag] == .read
        default: return false
        }
    }

    init(memory: Memory, inTape: Tape, outTape: Tape) {
        self.memory = memory
        self.inTape = inTape
        self.outTape = outTape
        self.runState = .halted
        self.runDescription = self.runState.description
    }
}
