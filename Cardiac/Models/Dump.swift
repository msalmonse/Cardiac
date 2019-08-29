//
//  Dump.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

// Class used to load data from JSON dump

class DumpData {
    var programCounter = 0
    var memory = [[String: Int]]()
    var input = [[String: Int]]()
}
