//
//  OpCode.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

struct Location {
    var label: String? = nil
    var address: Int? = nil
    var used: [Int] = []
}

enum OpCode {
    case inp(Location)
    case cla(Location)
    case add(Location)
    case tac(Location)
    case slr(Int, Int)
    case out(Location)
    case sto(Location)
    case sub(Location)
    case jmp(Location)
    case hrs(Location)
    case unk(Location)
}
