//
//  Cell.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

/// A memory cell

enum CellStatus {
    case ro, rw
}

class Cell: ObservableObject, Identifiable {
    private let range: ClosedRange<UInt16> = 0...999

    let id = UUID()

    private(set) var value: UInt16 {
        willSet { objectWillChange.send() }
        didSet { string = String(format: "%03d", value) }
    }

    @discardableResult
    func setValue(_ newValue: UInt16) -> Cell {
        if status == .rw && range.contains(newValue) { value = newValue}

        return self
    }

    private(set) var string = ""

    var opcode: UInt16 {
        return value/100
    }

    var address: UInt16 {
        return value % 100
    }

    let location: String

    var status: CellStatus = .rw

    @discardableResult
    func setRO() -> Cell { status = .ro; return self }

    @discardableResult
    func setRW() -> Cell { status = .rw; return self }

    init(_ location: Int, _ value: UInt16 = 0) {
        self.location = Memory.contains(location) ? String(format: "%02d", location) : ""
        self.value = value
        self.string = String(format: "%03d", value)
    }
}
