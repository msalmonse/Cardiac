//
//  ALU.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-01.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

// Arithmatic and logic unit

class ALU: ObservableObject, Identifiable {
    enum PlusMinus {
        case plus, minus, nosign
    }

    let id = UUID()

    let opA = Cell(-1)
    let opB = Cell(-1)
    let result = Cell(-1)
    var isNegative = false

    var operation: ALU.PlusMinus = .nosign
    var sign: ALU.PlusMinus {
        return isNegative ? .minus : .plus
    }

    func cla(_ opB: UInt16) {
        self.opA.setValue(0)
        self.opB.setValue(opB)
        self.result.setValue(self.opA + self.opB)
    }

    func add(_ opB: UInt16) {
        self.opA.setValue(result.value % 999)
        self.opB.setValue(opB)
        if isNegative {
            let (res, neg) = self.opB - self.opA
            result.setValue(res)
            isNegative = neg
        } else {
            self.result.setValue(opA + opB)
        }
    }

    func sub(_ opB: UInt16) {
        self.opA.setValue(result.value % 999)
        self.opB.setValue(opB)
        if !isNegative {
            let (res, neg) = self.opA - self.opB
            result.setValue(res)
            isNegative = neg
        } else {
            self.result.setValue(opA + opB)
        }
    }

    func shiftLeft(_ count: UInt16) {
        func slResult(_ mul: Int) {
            let shifted = Int(result.value) * mul
            result.setValue(UInt16(shifted % 10000))
        }
        switch count {
        case 0: break
        case 1: slResult(10)
        case 2: slResult(100)
        case 3: slResult(1000)
        default: result.setValue(0)
        }
    }

    func shiftRight(_ count: UInt16) {
        func srResult(_ div: Int) {
            let shifted = Int(result.value) / div
            result.setValue(UInt16(shifted % 10000))
        }
        switch count {
        case 0: break
        case 1: srResult(10)
        case 2: srResult(100)
        case 3: srResult(1000)
        default: result.setValue(0)
        }
    }

    init() {
        result.makeBig()
    }
}
