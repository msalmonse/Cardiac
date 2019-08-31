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

            VStack(spacing: 1) {
                DetailView(cell: memory[index - 1])
                DetailView(cell: memory[index])
                DetailView(cell: memory[index + 1])
            }
            .padding()
            .overlay(strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: .primary))

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
            if cell.status == .empty {
                Image(systemName: "x.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.horizontal, 50)
            } else {
                Text("Location: \(cell.location)")
                HStack {
                    Text("Value:")
                    if cell.status != .rw {
                        Text(cell.string)
                        } else {
                        TextField(
                            "Memory cell value",
                            text: $cell.string
                        )
                        .multilineTextAlignment(.trailing)
                        .frame(width: 75)
                    }
                }
                Text(instruction(cell))
                Text("Status: \(cell.status.description)")
            }
        }
        .font(.system(.headline, design: .monospaced))
        .padding()
        .overlay(strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: .primary))
    }
}

struct CellDetail_Previews: PreviewProvider {
    static var previews: some View {
        CellDetail(index: 0, memory: Memory())
    }
}
