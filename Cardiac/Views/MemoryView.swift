//
//  MemoryView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let columnOffset = 20
fileprivate let columns = 5

fileprivate let dummyCell = Cell(-1, 0)
struct MemoryView: View {
    var memory: Memory

    func conditionalCellView(_ index: Int) -> some View {
        return Memory.contains(index)
            ? CellView(index: index, cell: memory[index])
            : CellView(index: -1, cell: dummyCell)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(0..<columnOffset) {row in
                HStack(spacing: 1) {
                    ForEach(0..<columns) { column in
                        self.conditionalCellView(row + column * columnOffset)
                    }
                }
            }
        }
    }
}

struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryView(memory: Memory())
    }
}
