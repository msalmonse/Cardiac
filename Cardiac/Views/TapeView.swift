//
//  TapeView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let emptyCell = Cell.empty

struct TapeView: View {
    @ObservedObject var tape: Tape
    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(Tape.range, id: \.self) {index in
                    index < 0
                        ? TapeCell(cell: emptyCell, isHead: false)
                        : TapeCell(cell: self.tape[index], isHead: index == self.tape.head)
                }
            }
        }
    }
}

struct TapeCell: View {
    @ObservedObject var cell: Cell
    let isHead: Bool

    var body: some View {
        Text(cell.formattedValue)
        .padding(2)
        .overlay(strokedRectangle(stroke: 1, color: isHead ? .red : .primary))
    }
}
struct TapeView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TapeView(tape: Tape(.input))
            TapeView(tape: Tape(.output))
        }
    }
}
