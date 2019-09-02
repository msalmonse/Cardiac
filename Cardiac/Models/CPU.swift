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

class CPU: Identifiable {
    let id = UUID()

    let memory = Memory()
    let exec: ExecUnit

    var inTape = Tape(.input)
    var outTape = Tape(.output)

    init() {
        self.exec = ExecUnit(memory: memory, inTape: inTape, outTape: outTape)
    }

    func loadJsonResource(_ name: String) -> Result<Void, Error> {
        var url: URL
        switch bundledURL(name) {
        case .success(let ret): url = ret
        case .failure(let err): return .failure(err)
        }

        return loadJsonURL(url)
    }

    func loadJsonURL(_ url: URL) -> Result<Void, Error> {
        exec.runState = .loading

        var dump: DumpData
        switch loadFromJSON(url, as: DumpData.self) {
        case .success(let data): dump = data
        case .failure(let err): return .failure(err)
        }

        var err: Error? = nil

        exec.next = UInt16(dump.next)
        exec.address = exec.next

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
                inTape[addrData.address].setValue(addrData.data)
            case let .failure(error): err = error
            }
        }

        exec.runState = .halted
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
