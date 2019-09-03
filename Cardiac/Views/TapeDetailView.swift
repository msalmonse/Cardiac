//
//  TapeDetailView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-03.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let rows = 5
fileprivate let cols = 10

struct TapeDetailView: View {
    @ObservedObject var tape: Tape
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    func cellsPer(row: Int) -> Range<Int> {
        let rowStart = row * cols
        return rowStart..<(rowStart + cols)
    }

    var body: some View {
        ZStack {
            bgColor
            VStack {
                Spacer()
                Button(
                    action: { self.tape.rewind()},
                    label: { ButtonImage(systemName: "gobackward", font: .largeTitle) }
                )
                Spacer()

                ForEach(0..<rows) { row in
                    HStack {
                        ForEach(self.cellsPer(row: row)) { index in
                            TapeCellDetail(cell: self.tape[index], isHead: index == self.tape.head)
                        }
                    }
                }

                Spacer()

                Button(
                    action: { self.mode.wrappedValue.dismiss() },
                    label: { ButtonText("Dismiss", font: .title) }
                )

                Spacer()
            }
        }
    }
}

struct TapeCellDetail: View {
    @ObservedObject var cell: Cell
    let isHead: Bool

    var body: some View {
        TextField("Cell value", text: $cell.formattedValue)
        .multilineTextAlignment(.trailing)
        .frame(width: 50)
        .font(.system(.headline, design: .monospaced))
        .padding()
        .overlay(
            strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: isHead ? .red : .primary)
        )
    }
}

struct TapeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TapeDetailView(tape: Tape(.input))
    }
}
