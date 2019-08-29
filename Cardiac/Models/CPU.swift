//
//  CPU.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

class CPU {
    var memory = Memory()

    // System registers
    var operandA: Int = 0
    var operandB: Int = 0
    var result: Int = 0

    var programCounter: UInt8 = 0

    var inTape = Tape(.input)
    var outTape = Tape(.output)
}
