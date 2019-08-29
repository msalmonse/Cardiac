//
//  Memory.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

class Memory: Identifiable {
    static let size = 100
    static let range = 0..<size

    static func contains(_ value: Int) -> Bool {
        return range.contains(value)
    }

    let id = UUID()
    var cells: [Cell] = range.map { Cell($0, 900) }

    subscript(index: Int) -> Cell {
        get { return cells[index] }
        set { cells[index] = newValue }
    }

    init() {
        cells[0].setValue(1).lock()
        cells[99].setValue(800).setRO()
    }
}
