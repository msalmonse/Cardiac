//
//  Tape.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

fileprivate let tapeLength = 50

enum TapeError: Error {
    case endOfTape, roDevice, woDevice
}

extension TapeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .endOfTape: return "End of tape"
        case .roDevice: return "Write to read only device"
        case .woDevice: return "Read from write only device"
        }
    }
}

enum TapeInOut {
    case input, output
}

class Tape {
    var data = [UInt16]()
    var inOut: TapeInOut
    var head = 0

    func readNext() -> Result<UInt16, Error> {
        if inOut != .input { return .failure(TapeError.woDevice)}
        if head >= data.count { return .failure(TapeError.endOfTape) }
        let ret = data[head]
        head += 1
        return .success(ret)
    }

    func writeNext(_ value: UInt16) -> Result<Void, Error> {
        if inOut != .output { return .failure(TapeError.roDevice)}
        if data.count >= tapeLength { return .failure(TapeError.endOfTape) }
        data.append(value)
        return .success(Void())
    }

    init(_ inOut: TapeInOut) {
        self.inOut = inOut
    }
}
