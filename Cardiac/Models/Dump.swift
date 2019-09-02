//
//  Dump.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

// Class used to load data from JSON dump

class DumpData: Codable {
    var next = 0                            // next address to execute
    var memory = [[String: Int]]()          // memory contents as a dict
    var input: [[String: Int]]? = nil       // optional input as dict
    var comment: [String]? = nil            // optional comment, an array of one string per line

    enum CodingKeys: String, CodingKey {
        case next = "PC"
        case memory
        case input
        case comment
    }
}
