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
    case data(Location?, String)
    case opCode(Location?, OpCode)
    case location(Location?, Int)
    case error(Int, Error)
}

enum TokenError: Error {
    case addressOutOfRange(Int)
    case invalidNumber
    case redefinedLabel(String)
    case shiftOutOfRange(Int)
    case unknownOperation(String)
    case wrongNumberOfArguments
}

func addressValue(_ sub: Substring) -> Result<Int, Error> {
    guard let value = Int(sub) else { return .failure(TokenError.invalidNumber) }
    if !(0...99).contains(value) { return .failure(TokenError.addressOutOfRange(value)) }
    return .success(value)
}

fileprivate let expectedWords: [Substring: Int] = [
    "slr":  3
]

func tokenize(_ indata: String) -> [Tokens] {
    var tokens: [Tokens] = []
    var lineData = indata

    var lineCount = 0
    var lineAddress = 2
    var lineStart = lineData.startIndex
    while lineStart < lineData.endIndex {
        let lineEnd = lineData.firstIndex(of: "\n") ?? lineData.endIndex
        let lineStop = lineData.firstIndex(of: "#") ?? lineEnd  // Remove comments
        let line = lineData[lineStart..<min(lineStop, lineEnd)]
        lineCount += 1
        var words = line.split(separator: " ")

        if words.count > 0 {
            lineAddress += 1

            var label: Location? = nil
            // Test for label
            if words[0].hasSuffix(":") {
                label = Location.get(words[0].dropLast(1))
                words.removeFirst()
            }

            if label != nil && label!.address != nil {
                // redefined label
                tokens.append(.error(lineCount, TokenError.redefinedLabel(label!.label!)))
            } else if words.count != expectedWords[words[0]] ?? 2 {
                tokens.append(.error(lineCount, TokenError.wrongNumberOfArguments))
            } else {
                label?.address = lineAddress
                switch words[0] {
                case "dat": tokens.append(.data(label, String(words[1])))
                case "loc":
                    switch addressValue(words[1]) {
                    case let .success(addr):
                        lineAddress = addr
                        label?.address = addr
                        tokens.append(.location(label, addr))
                    case let .failure(err):
                        tokens.append(.error(lineCount, err))
                    }
                default:
                    switch opCodeToken(words) {
                    case let .success(opCode): tokens.append(.opCode(label, opCode))
                    case let .failure(err): tokens.append(.error(lineCount, err))
                    }
                }
            }
        }

        // move onto next line
        lineData.removeSubrange(lineStart...lineEnd)
        lineStart = lineData.startIndex
    }

    return tokens
}
