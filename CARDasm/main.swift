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
var outFormat = OutFormat.json

enum Action {
    case assemble, disassemble, help
}

var action = Action.assemble

if CommandLine.arguments.count <= 1 { usage(0) }

let argRange = 1..<CommandLine.arguments.count
var argi = argRange.lowerBound
while argRange.contains(argi) {
    let arg = CommandLine.arguments[argi]
    if arg.prefix(1) != "-" { break }
    if arg == "--" { // end of argument list
        argi += 1
        break
    }
    switch arg {
    case "-D", "--disassemble": action = .disassemble
    case "-O", "--output":
        if !argRange.contains(argi + 1) {
            errorUsage("Not enough argumnets for \(arg)", 1)
        } else {
            argi += 1
            outFile = .toFile(URL(fileURLWithPath: CommandLine.arguments[argi]))
        }
    case "--stdout": outFile = .stdout
    case "--tape": outFormat = .tape
    case "--to":
        if !argRange.contains(argi + 1) {
            errorUsage("Not enough argumnets for \(arg)", 1)
        } else {
            argi += 1
            outFile = .toDir(URL(fileURLWithPath: CommandLine.arguments[argi], isDirectory: true))
        }
    default:
        errorUsage("Unknown option: \(arg)\n", 1)
    }
    argi += 1
}

inFiles = CommandLine.arguments[ argi..<CommandLine.arguments.count ].map { $0 }

switch (outFile, inFiles.count) {
case (_, 0): errorUsage("No input files specified", 1)
case (.toFile, 1): break
case (.toFile, _): errorUsage("--output is not allowed with multiple input files", 1)
default: break
}

for file in inFiles {
    let url = URL(fileURLWithPath: file)
    switch action {
    case .assemble:
        switch assembleOneFile(url, to: outFile, as: outFormat) {
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
