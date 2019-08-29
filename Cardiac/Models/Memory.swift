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
    let id = UUID()
    var cells: [Cell] = (0..<size).map {_ in Cell() }

    subscript(index: Int) -> Cell {
        get { return cells[index] }
        set { cells[index] = newValue }
    }
}
