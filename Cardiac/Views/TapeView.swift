//
//  TapeView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let emptyCell = Cell.empty

struct TapeInView: View {
    @ObservedObject var tape: Tape

    var body: some View {
        VStack {
            VStack {
                Text("In")
                NavigationLink(
                    destination: TapeDetailView(tape: tape),
                    label: { Image(systemName: "pencil").padding() }
                )
            }
            .modifier(ContentView.Heading())
            TapeView(tape: tape)
        }
    }
}

struct TapeOutView: View {
    @ObservedObject var tape: Tape

    var body: some View {
        VStack {
            VStack {
                Text("Out")
                Button(
                    action: { self.tape.rewind() },
                    label: { Image(systemName: "gobackward").padding() }
                )
            }
            .modifier(ContentView.Heading())
            TapeView(tape: tape)
        }
    }
}

struct TapeView: View {
    @ObservedObject var tape: Tape

    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ForEach(0..<(10 - tape.head), id: \.self) {_ in
                        TapeCell(cell: emptyCell, isHead: false)
                }
                ForEach(Tape.range, id: \.self) {index in
                        TapeCell(cell: self.tape[index], isHead: index == self.tape.head)
                }
            }
        }
    }
}

struct TapeCell: View {
    @ObservedObject var cell: Cell
    let isHead: Bool

    var borderColor: Color {
        switch (isHead, cell.status == .empty) {
        case (_, true): return .clear
        case (true, false): return .red
        case (false, false): return .primary
        }
    }

    var body: some View {
        Text(cell.formattedValue)
        .foregroundColor(cell.valid ? .primary : .clear)
        .padding(2)
        .overlay(strokedRectangle(stroke: 1, color: borderColor))
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
