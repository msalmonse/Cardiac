//
//  Comment.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

struct Comment: Identifiable {
    let id = UUID()

    var lines: [String]

    var isEmpty: Bool { return lines.isEmpty }

    init(_ lines: [String]) {
        self.lines = lines
    }

    init(_ line: String) {
        self.init([line])
    }

    init() {
        self.init([])
    }
}
