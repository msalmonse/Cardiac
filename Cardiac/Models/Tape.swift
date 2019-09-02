//
//  Tape.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

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

class Tape: ObservableObject, Identifiable {
    static let size = 50
    static let range = 0..<size

    let id = UUID()
    var cells: [Cell] = range.map { Cell($0) }

    var inOut: TapeInOut
    @Published
    var head = 0

    func readNext() -> Result<UInt16, TapeError> {
        if inOut != .input { return .failure(.woDevice)}
        if head >= cells.count { return .failure(.endOfTape) }
        if !cells[head].valid { return .failure(.endOfTape) }
        let ret = cells[head].value
        head += 1
        return .success(ret)
    }

    func writeNext(_ value: UInt16) -> Result<Void, TapeError> {
        if inOut != .output { return .failure(.roDevice)}
        if head >= Tape.size { return .failure(.endOfTape) }
        cells[head].setValue(value)
        head += 1
        return .success(Void())
    }

    func rewind() {
        _ = cells.map { $0.inValidate() }
        head = 0
    }

    subscript(index: Int) -> Cell {
        get { return Self.range.contains(index) ? cells[index] : Cell.empty }
        set { if Self.range.contains(index) { cells[index] = newValue } }
    }

    subscript(uindex: UInt16) -> Cell {
        get { return self[Int(uindex)] }
        set { self[Int(uindex)] = newValue }
    }

    init(_ inOut: TapeInOut) {
        self.inOut = inOut
    }
}
