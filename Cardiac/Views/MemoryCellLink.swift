//
//  MemoryCellLink.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let emptyCell = Cell.empty

struct MemoryCellLink: View {
    let memory: Memory
    let index: Int

    func minMax() -> Int {
        return max(1, min(index, Memory.size - 3))
    }

    var body: some View {
        Group {
            if index < 0 {
                MemoryCellView(index: -1, cell: emptyCell)
            } else {
                NavigationLink(
                    destination: MemoryDetail(index: minMax(), memory: memory),
                    label: { MemoryCellView(index: index, cell: memory[index]) }
                )
            }
        }
    }
}

struct CellLink_Previews: PreviewProvider {
    static var previews: some View {
        MemoryCellLink(memory: Memory(), index: 0)
    }
}
