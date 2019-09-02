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
        get { return Self.range.contains(index) ? cells[index] : Cell.empty }
        set { if Self.range.contains(index) { cells[index] = newValue } }
    }

    subscript(uindex: UInt16) -> Cell {
        get { return self[Int(uindex)] }
        set { self[Int(uindex)] = newValue }
    }

    // set the activity indicators for all cells
    func setActivity(read: UInt16, write: UInt16, exec: UInt16) {
        _ = cells.filter({ $0.activity != .noactivity}).map { $0.setActivity(.noactivity) }
        if Self.range.contains(Int(read)) { self[read].setActivity(.reading) }
        if Self.range.contains(Int(write)) { self[write].setActivity(.writing) }
        if Self.range.contains(Int(exec)) { self[exec].setActivity(.executing) }
    }

    init() {
        cells[0].setValue(1).lock()
        cells[99].setValue(800).setRO()
    }
}
