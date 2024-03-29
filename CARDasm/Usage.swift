//
//  Usage.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-16.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

fileprivate var command = ""
fileprivate let usageText = """
Usage:
    \(command) [options]... <input files>...

Options:
    -D or --disassemble     Take a json dump and convert it to cardasm
    -O or --output <name>   Write the output to name
    --stdout                Write to stdout
    --tape                  Save output as a tape file
    --to <directory>        Save output files in directory
"""

func usage(_ exitCode: Int32 = -1, path: String) {
    command = URL(fileURLWithPath: path).lastPathComponent
    print(usageText)
    if exitCode >= 0 { exit(exitCode) }
}

func errorUsage(_ msg: String, _ exitCode: Int32 = -1, path: String) {
    print(msg)
    usage(exitCode, path: path)
}
