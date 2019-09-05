//
//  ExecUnit.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import Combine

enum RunState {
    case running(Double), stepping, halted, iowait, loading

    var description: String {
        switch self {
        case .halted: return "Halted"
        case .iowait: return "Waiting"
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
    var address: UInt16 = 0 { willSet { intAddress = Int(newValue) } }
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

    var opcode: OpCode {
        return memory[address].opcode
    }

    init(memory: Memory, inTape: Tape, outTape: Tape) {
        self.memory = memory
        self.inTape = inTape
        self.outTape = outTape
        self.runState = .halted
        self.runDescription = self.runState.description
    }
}
