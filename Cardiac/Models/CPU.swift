//
//  CPU.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

fileprivate struct AddressAndData {
    let address: UInt16
    let data: UInt16
}

class CPU {
    var memory = Memory()

    let alu = ALU()

    var execAddr: UInt16 = 0
    var execNext: UInt16 = 0

    var readAddr: UInt16 = 0
    var writeAddr: UInt16 = 0

    var inTape = Tape(.input)
    var outTape = Tape(.output)

    func loadJsonResource(_ name: String) -> Result<Void, Error> {
        var url: URL
        switch bundledURL(name) {
        case .success(let ret): url = ret
        case .failure(let err): return .failure(err)
        }

        return loadJsonURL(url)
    }

    func loadJsonURL(_ url: URL) -> Result<Void, Error> {
        var dump: DumpData
        switch loadFromJSON(url, as: DumpData.self) {
        case .success(let data): dump = data
        case .failure(let err): return .failure(err)
        }

        var err: Error? = nil

        execNext = UInt16(dump.next)

        for mem in dump.memory {
            switch oneCell(mem) {
            case let .success(addrData):
                memory[addrData.address].setValue(addrData.data)
            case let .failure(error): err = error
            }
        }

        for inp in dump.input ?? [] {
            switch oneCell(inp) {
            case let .success(addrData):
                inTape.data.append(addrData.data)   // FixME
            case let .failure(error): err = error
            }
        }

        return err == nil ? .success(Void()) : .failure(err!)
    }

    fileprivate func oneCell(_ dataIn: [String: Int]) -> Result<AddressAndData, Error> {
        let addr = dataIn["addr"]
        let data = dataIn["data"]
        if addr == nil || data == nil {
            return .failure(FileError.dataFormatError)
        }
        return .success(AddressAndData(address: UInt16(addr!), data: UInt16(data!)))
    }
}
