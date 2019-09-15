//
//  OneFile.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

func oneFile(inFile: String, outFile: String? = nil) -> Result<Void, Error> {
    return .success(Void())
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

func oneString(_ inData: String) -> Result<String, Error> {
    switch oneData(inData) {
    case let .failure(err): return .failure(err)
    case let .success(data):
        return .success(String(decoding: data, as: UTF8.self))
    }
}
