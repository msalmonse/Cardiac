//
//  OneFile.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func assembleOneFile(_ inFile: URL, to outFile: OutFileType = .stdout) -> Result<Void, Error> {
    var inString = ""
    do {
        let data = try Data(contentsOf: inFile)
        inString = String(decoding: data, as: UTF8.self)
    } catch {
        return .failure(error)
    }

    var outData = Data()
    switch oneData(inString, pretty: outFile.pretty) {
    case let .failure(err): return .failure(err)
    case let .success(data): outData = data
    }

    switch saveToOutFile(outData, to: outFile, from: inFile, as: .json) {
    case let .failure(err): return .failure(err)
    case .success: return .success(Void())
    }
}

func oneData(_ inData: String, pretty: Bool = false) -> Result<Data, Error> {
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
