//
//  Breakpoint.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-08.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

enum BreakOn {
    case never, read, write, execute

    static func += (left: inout BreakOn, right: Int) {
        switch (left, right) {
        case (.execute, 1): left = .read
        case (.never, 1): left = .execute
        case (.read, 1): left = .write
        case (.write, 1): left = .never
        default: return
        }
    }

    static func -= (left: inout BreakOn, right: Int) {
        switch (left, right) {
        case (.execute, 1): left = .never
        case (.never, 1): left = .write
        case (.read, 1): left = .execute
        case (.write, 1): left = .read
        default: return
        }
    }
}

extension BreakOn: CustomStringConvertible {
    var description: String {
        switch self {
        case .execute: return "On Execute"
        case .never: return "Never"
        case .read: return "On Read"
        case .write: return "On Write"
        }
    }
}

struct BreakPoint {
    static private var breakPoints: [String: BreakOn] = [:]

    static subscript(_ tag: String) -> BreakOn {
        get { return breakPoints[tag] ?? .never }
        set { breakPoints[tag] = newValue }
    }
}
