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

fileprivate func saveToURL(_ data: Data, _ url: URL) -> Result<Void, Error> {
    switch createDirectoryContaining(url: url) {
    case .success: break
    case .failure(let error): return .failure(error)
    }

    do {
        try data.write(to: url)
    } catch {
        return .failure(error)
    }
    return .success(Void())
}

fileprivate func saveToDir(_ data: Data, _ dir: URL, _ inFile: URL) -> Result<Void, Error> {
    var name = inFile.lastPathComponent
    let ext = inFile.pathExtension
    if !ext.isEmpty { name.removeLast(ext.count + 1) }
    name += ".json"
    return saveToURL(data, dir.appendingPathComponent(name))
}

func saveToOutFile(
    _ data: Data,
    to outFile: OutFileType,
    from inFile: URL
) -> Result<Void, Error> {
    switch outFile {
    case .stdout: print(String(decoding: data, as: UTF8.self))
    case let .toFile(url): return saveToURL(data, url)
    case .notspecified:
        return saveToDir(data, inFile.deletingLastPathComponent(), inFile)
    case let .toDir(url):
        return saveToDir(data, url, inFile)
    }

    return .success(Void())
}
