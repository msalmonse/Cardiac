//
//  OutFile.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-15.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

enum OutFileType {
    case notspecified
    case toDir(URL)
    case toFile(URL)
    case stdout

    var pretty: Bool {
        switch self {
        case .stdout: return true
        default: return false
        }
    }
}

func saveToOutFile(
    _ data: Data,
    to outFile: OutFileType,
    from inFile: URL
) -> Result<Void, Error> {
    switch outFile {
    case .stdout: print(String(decoding: data, as: UTF8.self))
    default: break
    }
    return .success(Void())
}
