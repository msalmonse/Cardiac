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
    var negativeOpA = false

    @Published
    var operation: ALU.PlusMinus = .nosign
    var sign: ALU.PlusMinus {
        return isNegative ? .minus : .plus
    }
    var opAsign: ALU.PlusMinus {
        return negativeOpA ? .minus : .plus
    }

    func cla(_ opBvalue: UInt16) {
        opA.setValue(0)
        negativeOpA = false
        opB.setValue(opBvalue)
        operation = .plus
        result.setValue(opA + opB)
        isNegative = false
    }

    func add(_ opBvalue: UInt16) {
        opA.setValue(result.value % 999)
        negativeOpA = isNegative
        opB.setValue(opBvalue)
        operation = .plus
        if negativeOpA {
            let (res, neg) = opB - opA
            result.setValue(res)
            isNegative = neg
        } else {
            result.setValue(opA + opB)
        }
    }

    func sub(_ opBvalue: UInt16) {
        opA.setValue(result.value % 999)
        negativeOpA = isNegative
        opB.setValue(opBvalue)
        operation = .minus
        if !negativeOpA {
            let (res, neg) = opA - opB
            result.setValue(res)
            isNegative = neg
        } else {
            result.setValue(opA + opB)
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

    // clear the operation flag
    func noop() {
        operation = .nosign
    }

    init() {
        result.makeBig()
    }
}
