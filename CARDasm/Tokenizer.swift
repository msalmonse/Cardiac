//
//  Tokenizer.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//
// swiftlint:disable cyclomatic_complexity function_body_length

import Foundation

enum Tokens {
    case comment(String)
    case data(Int, Location, String)
    case error(Int, Error)
    case location(Int, Location, Int)
    case opCode(Int, Location, OpCode)
    case tape(Int, String)
}

enum TokenError: Error {
    case addressOutOfRange(Int)
    case invalidNumber(String)
    case redefinedLabel(String)
    case shiftOutOfRange(Int)
    case undefinedLabel(String)
    case unknownError
    case unknownOperation(String)
    case valueOutOfRange(Int)
    case wrongNumberOfArguments
}

extension TokenError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .addressOutOfRange(addr): return "Address \(addr) is not allowed"
        case let .invalidNumber(string): return "\(string) is not a valid number"
        case let .redefinedLabel(label): return "\(label) has been defined twice"
        case let .shiftOutOfRange(shift): return "Can't shift by \(shift)"
        case let .undefinedLabel(label): return "\(label) has not been defined"
        case .unknownError: return "Something bad happened"
        case let .unknownOperation(opcode): return "Operation \(opcode) is not valid"
        case let .valueOutOfRange(value): return "Value \(value) is not allowed"
        case .wrongNumberOfArguments: return "Wrong number of Arguments"
        }
    }
}

func dataValue(_ sub: Substring) -> Result<Int, Error> {
    if let data = Int(sub) {
        if (0...999).contains(data) { return .success(data) }
        return .failure(TokenError.valueOutOfRange(data))
    }
    let location = Location.get(sub)
    if let data = location.address { return .success(data) }
    return .failure(TokenError.invalidNumber(String(sub)))
}

func addressValue(_ sub: Substring) -> Result<Int, Error> {
    guard let value = Int(sub) else { return .failure(TokenError.invalidNumber(String(sub))) }
    if !(0...99).contains(value) { return .failure(TokenError.addressOutOfRange(value)) }
    return .success(value)
}

fileprivate let expectedWords: [Substring: Int] = [
    "comment": 1,
    "slr":  3
]

func tokenize(_ indata: String) -> [Tokens] {
    var tokens: [Tokens] = []
    var inComment = false

    var lineCount = 0
    var lineAddress = 2
    for var line in indata.split(separator: "\n", omittingEmptySubsequences: false) {
        if let commentStart = line.firstIndex(of: "#") {
            line.removeSubrange(commentStart...)
        }
        lineCount += 1

        if inComment {
            if line == "endcomment" {
                inComment = false
            } else {
                tokens.append(.comment(String(line)))
            }
        } else {
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
                    case "bss":     // block started by symbol
                        switch addressValue(words[1]) {
                        case let .success(addr):
                            if addr + lineAddress > 98 {
                                tokens.append(
                                    .error(
                                        lineCount,
                                        TokenError.addressOutOfRange(addr + lineAddress)
                                    )
                                )
                            } else {
                                lineAddress += addr - 1
                                tokens.append(.location(lineCount, location, lineAddress + 1))
                            }
                        case let .failure(err):
                            tokens.append(.error(lineCount, err))
                        }
                    case "comment":
                        inComment = true
                    case "dat": tokens.append(.data(lineCount, location, String(words[1])))
                    case "loc":
                        switch addressValue(words[1]) {
                        case let .success(addr):
                            lineAddress = addr - 1      // will be incremented on next line
                            location.address = addr
                            tokens.append(.location(lineCount, location, addr))
                        case let .failure(err):
                            tokens.append(.error(lineCount, err))
                        }
                    case "tape": tokens.append(.tape(lineCount, String(words[1])))
                    default:
                        switch opCodeToken(words) {
                        case let .success(opCode): tokens.append(.opCode(lineCount, location, opCode))
                        case let .failure(err): tokens.append(.error(lineCount, err))
                        }
                    }
                }
            }
        }
    }

    return tokens
}
