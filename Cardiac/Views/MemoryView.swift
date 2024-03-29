//
//  MemoryView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let columnOffset = 17
fileprivate let columns = 6

struct MemoryView: View {
    var memory: Memory

    func conditionalCellView(_ index: Int) -> some View {
        return Memory.contains(index)
            ? MemoryCellLink(memory: memory, index: index)
            : MemoryCellLink(memory: memory, index: -1)
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
