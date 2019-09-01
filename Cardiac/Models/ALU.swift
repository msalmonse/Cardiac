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
    let id = UUID()

    let opA = Cell(-1)
    let opB = Cell(-1)
    let result = Cell(-1)
    var isNegative = false

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

    init() {
        result.makeBig()
    }
}
