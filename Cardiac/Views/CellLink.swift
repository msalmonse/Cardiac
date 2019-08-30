//
//  CellLink.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let dummyCell = Cell(-1, 0)

struct CellLink: View {
    let memory: Memory
    let index: Int

    var body: some View {
        Group {
            if index < 0 {
                CellView(index: -1, cell: dummyCell)
            } else {
                NavigationLink(
                    destination: CellDetail(index: index, memory: memory),
                    label: { CellView(index: index, cell: memory[index]) }
                )
            }
        }
    }
}

struct CellLink_Previews: PreviewProvider {
    static var previews: some View {
        CellLink(memory: Memory(), index: 0)
    }
}
