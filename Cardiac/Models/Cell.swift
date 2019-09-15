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
    case ro, rw, locked, empty
}

enum CellActivity {
    case noactivity, reading, writing, executing

    var color: Color {
        switch self {
        case .executing:    return .blue
        case .noactivity:   return .primary
        case .reading:      return .green
        case .writing:      return .red
        }
    }
}

extension CellStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .empty:  return "Empty"
        case .locked: return "Locked"
        case .ro:     return "Read Only"
        case .rw:     return "Read/Write"
        }
    }
}

fileprivate let cellRange: ClosedRange<UInt16> = 0...999
fileprivate let bigRange: ClosedRange<UInt16> = 0...9999

class Cell: ObservableObject, Identifiable {
    private var range = cellRange
    private var format = "%03d"

    let id = UUID()
    var tag: String

    @Published
    var breakPoint = BreakOn.never

    @Published
    private(set) var value: UInt16

    @discardableResult
    func setValue(_ newValue: UInt16, overwrite: Bool = false) -> Cell {
        if range.contains(newValue) && value != newValue {
            switch (status, overwrite) {
            case (.rw, _), (.ro, true):
                value = newValue
                valid = true
            default: break
            }
        }

        return self
    }

    var formattedValue: String {
        get {
            return String(format: format, Int(value))
        }
        set {
            guard let num = UInt16(newValue) else { return }
            setValue(num)
        }
    }

    // Add 2 cells
    static func + (left: Cell, right: Cell) -> UInt16 {
        return left.value + right.value
    }

    // Add UInt to cell
    static func + (left: Cell, right: UInt16) -> UInt16 {
        return left.value + right
    }

    // Subtract 2 cells
    static func - (left: Cell, right: Cell) -> (UInt16, Bool) {
        return left < right
            ? (right.value - left.value, true)
            : (left.value - right.value, false)
    }

    // Subtract UInt from cell
    static func - (left: Cell, right: UInt16) -> (UInt16, Bool) {
        return left < right
            ? (right - left.value, true)
            : (left.value - right, false)
    }

    // Less than
    static func < (left: Cell, right: Cell) -> Bool {
        return left.value < right.value
    }

    // Less than
    static func < (left: Cell, right: UInt16) -> Bool {
        return left.value < right
    }

    var opcode: OpCode {
        return valid ? OpCode.opcode(value/100, value % 100) : .inv(value)
    }

    let location: String

    @Published
    var activity: CellActivity = .noactivity
    var status: CellStatus = .rw
    private(set) var valid = false

    @discardableResult
    func lock() -> Cell {
        status = .locked
        return self
    }

    @discardableResult
    func setRO() -> Cell {
        if status == .rw { status = .ro }
        return self
    }

    @discardableResult
    func setRW() -> Cell {
        if status == .ro { status = .rw }
        return self
    }

    @discardableResult
    func setActivity(_ newActivity: CellActivity) -> Cell {
        switch (status, newActivity) {
        case (.empty, _):      activity = .noactivity
        case (_, .executing):  activity = .executing
        case (_, .noactivity): activity = .noactivity
        case (_, .reading):    activity = .reading
        case (.rw, .writing):  activity = .writing
        case (_, .writing):    activity = .noactivity
        }

        return self
    }

    @discardableResult
    func makeBig() -> Cell {
        range = bigRange
        format = "%04d"

        return self
    }

    func inValidate() {
        valid = false
        value = 0
    }

    init(_ location: Int, _ value: UInt16 = 0) {
        self.location = Memory.contains(location) ? String(format: "%02d", location) : ""
        self.value = value
        self.tag = self.id.uuidString
    }

    static var empty: Cell {
        let cell = Cell(-1)
        cell.status = .empty

        return cell
    }
}
