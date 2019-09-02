//
//  ExecUnit.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

enum RunState {
    case running, stepping, halted, iowait, loading
}

class ExecUnit: ObservableObject, Identifiable {
    let id = UUID()

    @Published
    var intAddress = 0
    var address: UInt16 = 0 { didSet { intAddress = Int(address) } }
    var next: UInt16 = 0

    var runState = RunState.halted

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
    }
}
