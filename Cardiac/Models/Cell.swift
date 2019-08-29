//
//  Cell.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

/// A memory cell

class Cell: ObservableObject, Identifiable {
    let id = UUID()

    @Published
    var value: UInt16

    var opcode: UInt16 {
        return value/100
    }

    var address: UInt16 {
        return value % 100
    }

    init(_ value: UInt16 = 0) {
        self.value = value
    }
}
