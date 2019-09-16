//
//  main.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

var inFiles: [String] = []
var outFile = OutFileType.notspecified

enum Action {
    case assemble, disassemble, help
}

var action = Action.assemble

enum NextArgDestination {
    case inFile
    case noDestination
    case outDir
    case outFile
}

var argDestination = NextArgDestination.noDestination

for arg in CommandLine.arguments.dropFirst() {
    switch argDestination {
    case .inFile:
        inFiles.append(arg)
        continue
    case .outFile: outFile = .toFile(URL(fileURLWithPath: arg))
    case .outDir: outFile = .toDir(URL(fileURLWithPath: arg, isDirectory: true))
    default:
        switch arg {
        case "--":
            argDestination = .inFile
            continue
        case "-D", "--disassemble":
            action = .disassemble
        case "-O", "--output":
            argDestination = .outFile
            continue
        case "--stdour": outFile = .stdout
        case "--to":
            argDestination = .outDir
        default:
            inFiles.append(arg)
        }
    }
    argDestination = .noDestination
}

switch argDestination {
case .inFile, .noDestination: break
default: fatalError("Missing parameter")
}

switch (outFile, inFiles.count) {
case (_, 0): fatalError("No input files specified")
case (.toFile, 1): break
case (.toFile, _): fatalError("--output is not allowed with multiple input files")
default: break
}

for file in inFiles {
    let url = URL(fileURLWithPath: file)
    switch action {
    case .assemble:
        switch assembleOneFile(url, to: outFile) {
        case let .failure(err): print("\(err)")
        case .success: break
        }
    case .disassemble:
        switch disassembleOneFile(url, to: outFile) {
        case let .failure(err): print("\(err)")
        case .success: break
        }
    case .help: break
    }
}
