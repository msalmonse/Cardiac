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

    // set the activity indicators for all cells
    func setActivity(read: Int, write: Int, exec: Int) {
        _ = cells.map { $0.setActivity(.noactivity) }
        if Self.range.contains(read) { cells[read].setActivity(.reading) }
        if Self.range.contains(write) { cells[write].setActivity(.writing) }
        if Self.range.contains(exec) { cells[exec].setActivity(.executing) }
    }

    init() {
        cells[0].setValue(1).lock()
        cells[99].setValue(800).setRO()
    }
}
