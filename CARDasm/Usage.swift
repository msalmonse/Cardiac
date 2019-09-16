//
//  Usage.swift
//  CARDasm
//
//  Created by Michael Salmon on 2019-09-16.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

fileprivate let usageText = """
Usage:
    cardasm [options]... <input files>...

Options:
    -D or --disassemble     Take a json dump and convert it to cardasm
    -O or --output <name>   Write the output to name
    --stdout                Write to stdout
    --to <directory>        Save output files in directory
"""

func usage() {
    print(usageText)
}
