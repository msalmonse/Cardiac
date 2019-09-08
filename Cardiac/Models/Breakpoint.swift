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
}

struct BreakPoint {
    static private var breakPoints: [String: BreakOn] = [:]

    static subscript(_ tag: String) -> BreakOn {
        get { return breakPoints[tag] ?? .never }
        set { breakPoints[tag] = newValue }
    }
}
