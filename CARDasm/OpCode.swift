//
//  OpCode.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

class Location {
    var label: String? = nil
    var address: Int? = nil
    var used: [Int] = []

    init(_ sub: Substring) {
        // check for numeric argument
        switch addressValue(sub) {
        case let .success(addr): address = addr
        case .failure:
            // Has location already been defined?
            label = String(sub)
            locations[label!] = self
        }
    }

    static func get(_ sub: Substring) -> Location {
        let label = String(sub)
        if let location = locations[label] { return location }
        return Location(sub)
    }
}

var locations = [String: Location]()

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

fileprivate func shiftVal(_ sub: Substring)  -> Result<Int, Error> {
    guard let value = Int(sub) else { return .failure(TokenError.invalidNumber) }
    if !(0...9).contains(value) { return .failure(TokenError.shiftOutOfRange(value)) }
    return .success(value)
}

func opCodeToken(_ words: [Substring]) -> Result<OpCode, Error> {
    switch words[0] {
    case "inp": return .success(.inp(Location.get(words[1])))
    case "cla": return .success(.cla(Location.get(words[1])))
    case "add": return .success(.add(Location.get(words[1])))
    case "tac": return .success(.tac(Location.get(words[1])))
    case "slr":
        var sl = 0
        switch shiftVal(words[1]) {
        case let .success(slval): sl = slval
        case let .failure(err): return .failure(err)
        }
        switch shiftVal(words[2]) {
        case let .success(srval): return .success(.slr(sl, srval))
        case let .failure(err): return .failure(err)
        }
    case "out": return .success(.out(Location.get(words[1])))
    case "sto": return .success(.sto(Location.get(words[1])))
    case "sub": return .success(.sub(Location.get(words[1])))
    case "jmp": return .success(.jmp(Location.get(words[1])))
    case "hrs": return .success(.hrs(Location.get(words[1])))
    default: return .failure(TokenError.unknownOperation(String(words[0])))
    }
}
