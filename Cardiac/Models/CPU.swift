//
//  CPU.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

class CPU: Identifiable {
    let id = UUID()

    let memory = Memory()
    let exec: ExecUnit

    var inTape = Tape(.input)
    var outTape = Tape(.output)

    init() {
        self.exec = ExecUnit(memory: memory, inTape: inTape, outTape: outTape)
    }

    func loadFromResource(_ name: String) -> Result<Void, Error> {
        switch bundledURL(name, withExtension: "json") {
        case let .success(url):
            return loadFromURL(url, fromJSON: true)
        case .failure: break
        }

        switch bundledURL(name, withExtension: "tape") {
        case let .success(url):
            return loadFromURL(url, fromJSON: false)
        case let .failure(err): return .failure(err)
        }
    }

    func loadFromURL(_ url: URL, fromJSON: Bool) -> Result<Void, Error> {
        exec.halt(.loading)

        var dump: DumpData
        switch fromJSON ? loadFromJSON(url, as: DumpData.self) : loadFromTape(url) {
        case .success(let data): dump = data
        case .failure(let err): return .failure(err)
        }

        var err: Error? = nil

        exec.next = UInt16(dump.next)
        exec.address = exec.next

        for mem in dump.memory {
            switch oneCell(mem) {
            case let .success(addrData):
                memory[UInt16(addrData.address)].setValue(UInt16(addrData.data))
            case let .failure(error): err = error
            }
        }

        for inp in dump.input ?? [] {
            switch oneCell(inp) {
            case let .success(addrData):
                inTape[UInt16(addrData.address)].setValue(UInt16(addrData.data))
                if inTape.head > addrData.address {
                    inTape.head = Int(addrData.address)
                }
            case let .failure(error): err = error
            }
        }

        exec.comment = Comment(dump.comment ?? [])

        exec.halt()
        return err == nil ? .success(Void()) : .failure(err!)
    }
}
