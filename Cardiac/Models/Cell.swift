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

class Cell: ObservableObject, Identifiable {
    private let range: ClosedRange<UInt16> = 0...999

    let id = UUID()

    private(set) var value: UInt16 {
        willSet { objectWillChange.send() }
        didSet { string = String(format: "%03d", value) }
    }

    @discardableResult
    func setValue(_ newValue: UInt16, overwrite: Bool = false) -> Cell {
        if range.contains(newValue) && value != newValue {
            switch (status, overwrite) {
            case (.rw, _), (.ro, true):
                value = newValue
            default: break
            }
        }

        return self
    }

    var string = "" {
        willSet { objectWillChange.send() }
        didSet {
            if string != oldValue {
                guard let val = UInt16(string) else {
                    string = oldValue
                    objectWillChange.send()
                    return
                }
                setValue(val)
                if value != val {
                    string = oldValue
                    objectWillChange.send()
                }
            }
        }
    }

    var opcode: UInt16 {
        return value/100
    }

    var address: UInt16 {
        return value % 100
    }

    let location: String

    var activity: CellActivity = .noactivity
    var status: CellStatus = .rw

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

    init(_ location: Int, _ value: UInt16 = 0) {
        self.location = Memory.contains(location) ? String(format: "%02d", location) : ""
        self.value = value
        self.string = String(format: "%03d", value)
    }

    static var empty: Cell {
        let cell = Cell(-1)
        cell.string = ""
        cell.status = .empty

        return cell
    }
}
