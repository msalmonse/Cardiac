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
    case data
    case opCode(OpCode)
    case location(String)
}

func tokenize(_ indata: String) -> [Tokens] {
    var tokens: [Tokens] = []

    return tokens
}
