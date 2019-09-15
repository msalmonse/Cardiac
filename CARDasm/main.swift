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

enum NextArgDestination {
    case noDestination
    case outFile
}

var argDestination = NextArgDestination.noDestination

for arg in CommandLine.arguments.dropFirst() {
    switch argDestination {
    case .outFile: outFile = .toFile(URL(fileReferenceLiteralResourceName: arg))
    default:
        switch arg {
        case "-output":
            argDestination = .outFile
            continue
        case "--stdour": outFile = .stdout
        default:
            inFiles.append(arg)
        }
    }
    argDestination = .noDestination
}

if argDestination != .noDestination {
    fatalError("Missing parameter")
}
