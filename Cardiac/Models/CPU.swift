//
//  CPU.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

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

        execNext = UInt16(dump.programCounter)

        for mem in dump.memory {
            let addr = mem["addr"]
            let data = mem["data"]
            if addr == nil || data == nil {
                err = FileError.dataFormatError
                continue
            }
            memory[addr!].setValue(UInt16(data!))
        }

        return err == nil ? .success(Void()) : .failure(err!)
    }
}
