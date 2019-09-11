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
    case data(Location, String)
    case opCode(Location, OpCode)
    case location(Location, Int)
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

    var lineCount = 0
    var lineAddress = 2
    for var line in indata.split(separator: "\n", omittingEmptySubsequences: false) {
        if let commentStart = line.firstIndex(of: "#") {
            line.removeSubrange(commentStart...)
        }
        lineCount += 1
        var words = line.split(separator: " ")

        if words.count > 0 {
            lineAddress += 1

            var location = Location(lineAddress)
            // Test for label
            if words[0].hasSuffix(":") {
                location = Location.get(words[0].dropLast(1))
                if location.address == nil { location.address = lineAddress }
                words.removeFirst()
            }

            if location.label != nil && location.address != lineAddress {
                // redefined label
                tokens.append(.error(lineCount, TokenError.redefinedLabel(location.label!)))
            } else if words.count != expectedWords[words[0]] ?? 2 {
                tokens.append(.error(lineCount, TokenError.wrongNumberOfArguments))
            } else {
                switch words[0] {
                case "dat": tokens.append(.data(location, String(words[1])))
                case "loc":
                    switch addressValue(words[1]) {
                    case let .success(addr):
                        lineAddress = addr
                        location.address = addr
                        tokens.append(.location(location, addr))
                    case let .failure(err):
                        tokens.append(.error(lineCount, err))
                    }
                default:
                    switch opCodeToken(words) {
                    case let .success(opCode): tokens.append(.opCode(location, opCode))
                    case let .failure(err): tokens.append(.error(lineCount, err))
                    }
                }
            }
        }
    }

    return tokens
}
