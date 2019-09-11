//
//  Tokenizer.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

enum Tokens {
    case identifier(String)
    case number(String)
    case data(String?, String)
    case opCode(String?, OpCode)
    case location(String)
}

func tokenize(_ indata: String) -> [Tokens] {
    var tokens: [Tokens] = []
    var lineData = indata

    var lineStart = lineData.startIndex
    while lineStart < lineData.endIndex {
        let lineEnd = lineData.firstIndex(of: "\n") ?? lineData.endIndex
        let lineStop = lineData.firstIndex(of: "#") ?? lineEnd  // Remove comments
        let line = lineData[lineStart..<min(lineStop, lineEnd)]
        var words = line.split(separator: " ")

        if words.count > 0 {
            var label: String? = nil
            // Test for label
            if words[0].hasSuffix(":") {
                label = String(words[0].dropLast(1))
                words.removeFirst()
            }

            switch words[0] {
            case "dat":
                tokens.append(.data(label, String(words[1])))
            default:
                break
            }
        }

        // move onto next line
        lineData.removeSubrange(lineStart...lineEnd)
        lineStart = lineData.startIndex
    }

    return tokens
}
