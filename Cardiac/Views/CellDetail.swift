//
//  CellDetail.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CellDetail: View {
    @State var index: Int
    var memory: Memory

    var body: some View {
        VStack {
            Button(
                action: { self.index -= 1 },
                label: { Image(systemName: "chevron.up.circle.fill").font(.largeTitle) }
            )
            .disabled(index <= 0)

            DetailView(cell: memory[index])
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: .primary))
            .padding()

            Button(
                action: { self.index += 1 },
                label: { Image(systemName: "chevron.down.circle.fill").font(.largeTitle) }
            )
            .disabled(index + 1 >= Memory.size)
        }
    }
}

struct DetailView: View {
    @ObservedObject var cell: Cell

    var body: some View {
        VStack(alignment: .leading) {
            Text("Location: \(cell.location)")
            Text("Value: \(cell.string)")
            Text(instruction(cell))
            Text("Status: \(cell.status.description)")
        }
    }
}

struct CellDetail_Previews: PreviewProvider {
    static var previews: some View {
        CellDetail(index: 0, memory: Memory())
    }
}
