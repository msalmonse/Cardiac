//
//  OneFile.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func assembleOneFile(
    _ inFile: URL,
    to outFile: OutFileType = .stdout,
    as extent: OutFormat = .json
) -> Result<Void, Error> {

    var inString = ""
    do {
        let data = try Data(contentsOf: inFile)
        inString = String(decoding: data, as: UTF8.self)
    } catch {
        return .failure(error)
    }

    var outData = Data()
    switch extent {
    case .json:
        switch oneJSON(inString, pretty: outFile.pretty) {
        case let .failure(err): return .failure(err)
        case let .success(data): outData = data
        }
    case .tape:
        switch oneTape(inString) {
        case let .failure(err): return .failure(err)
        case let .success(data): outData = data
        }
    case .cardasm:
        return .failure(TokenError.unknownError)
    }

    switch saveToOutFile(outData, to: outFile, from: inFile, as: extent) {
    case let .failure(err): return .failure(err)
    case .success: return .success(Void())
    }
}

func oneJSON(_ inData: String, pretty: Bool = false) -> Result<Data, Error> {
    switch parse(inData) {
    case let .failure(err): return .failure(err)
    case let .success(dump):
        do {
            let encoder = JSONEncoder()
            if pretty { encoder.outputFormatting = .prettyPrinted }
            let data = try encoder.encode(dump)
            return .success(data)
        } catch {
            return .failure(error)
        }

    }
}

func oneTape(_ inData: String) -> Result<Data, Error> {
    switch parse(inData) {
    case let .failure(err): return .failure(err)
    case let .success(dump):
        var data = Data(capacity: 500)
        let encoder = Base32Encoder()
        // Add boot loader
        data.append(contentsOf: encoder.octets(2, 800))
        for mem in dump.memory {
            switch oneCell(mem) {
            case let .failure(err): return .failure(err)
            case let .success(addrData):
                data.append(contentsOf: encoder.octets(addrData))
            }
        }
        // add hrs start
        data.append(contentsOf: encoder.octets(900 + dump.next))

        for tape in dump.input ?? [] {
            switch oneCell(tape) {
            case let .failure(err): return .failure(err)
            case let .success(addrData):
                data.append(contentsOf: encoder.octets(addrData.data))
            }
        }

        if dump.comment != nil {
            let comment = "~\n" + dump.comment!.joined(separator: "\n") + "\n"
            data.append(contentsOf: [UInt8](comment.utf8))
        }

        return .success(data)
    }
}

func disassembleOneFile(_ inFile: URL, to outFile: OutFileType = .stdout) -> Result<Void, Error> {
    var dump: DumpData

    switch loadFromJSON(inFile, as: DumpData.self) {
    case .success(let data): dump = data
    case .failure(let err): return .failure(err)
    }

    let asm = disAssemble(dump)
    guard let data = asm.data(using: .utf8) else {
        return .failure(TokenError.unknownError)
    }
    switch saveToOutFile(data, to: outFile, from: inFile, as: .cardasm) {
    case let .failure(err): return .failure(err)
    case .success: return .success(Void())
    }
}
