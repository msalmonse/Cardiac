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

struct MemoryView: View {
    var memory: Memory

    func conditionalCellView(_ index: Int) -> some View {
        return index >= Memory.size
            ? CellView(index: -1, cell: memory[0])
            : CellView(index: index, cell: memory[index])
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<columnOffset) {row in
                HStack {
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
