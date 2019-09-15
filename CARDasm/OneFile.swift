//
//  OneFile.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func oneFile(_ inFile: URL, to outFile: OutFileType = .stdout) -> Result<Void, Error> {
    var inString = ""
    do {
        let data = try Data(contentsOf: inFile)
        inString = String(decoding: data, as: UTF8.self)
    } catch {
        return .failure(error)
    }

    var outData = Data()
    switch oneData(inString) {
    case let .failure(err): return .failure(err)
    case let .success(data): outData = data
    }

    switch saveToOutFile(outData, to: outFile, from: inFile) {
    case let .failure(err): return .failure(err)
    case .success: return .success(Void())
    }
}

func oneData(_ inData: String) -> Result<Data, Error> {
    switch parse(inData) {
    case let .failure(err): return .failure(err)
    case let .success(dump):
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(dump)
            return .success(data)
        } catch {
            return .failure(error)
        }

    }
}
