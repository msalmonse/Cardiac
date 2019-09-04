//
//  Comment.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

class Comment: Identifiable {
    let id = UUID()

    var lines: [String]

    init(_ lines: [String]) {
        self.lines = lines
    }

    convenience init(_ line: String) {
        self.init([line])
    }

    convenience init() {
        self.init([])
    }
}
