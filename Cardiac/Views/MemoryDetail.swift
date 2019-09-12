//
//  MemoryDetail.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-30.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct MemoryDetail: View {
    @State var index: Int
    var memory: Memory
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            bgColor
            VStack {
                HStack {
                    Button(
                        action: { self.index -= 1 },
                        label: {
                            ButtonImage(systemName: "chevron.up.circle.fill", font: .largeTitle)
                        }
                    )
                    .disabled(index <= 0)

                    VStack(spacing: 1) {
                        DetailView(cell: memory[index - 1])
                        DetailView(cell: memory[index])
                        DetailView(cell: memory[index + 1])
                        DetailView(cell: memory[index + 2])
                    }
                    .padding()
                    .overlay(strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: .green))

                    Button(
                        action: { self.index += 1 },
                        label: {
                            ButtonImage(systemName: "chevron.down.circle.fill", font: .largeTitle)
                        }
                    )
                    .disabled(index + 1 >= Memory.size)

                }

                Button(
                    action: { self.mode.wrappedValue.dismiss() },
                    label: { ButtonText("Dismiss", font: .title) }
                )
            }
        }
    }
}

fileprivate struct BreakPointBackground: ViewModifier {
    let fg: Color

    func body(content: Content) -> some View {
        content
            .foregroundColor(fg)
            .font(.body)
            .padding(2)
            .clipShape(Capsule())
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
                        Text(cell.formattedValue)
                    } else {
                        TextField("Cell value", text: $cell.formattedValue)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 50)
                    }
                }
                Text(instruction(cell))
                Text("Status: \(cell.status.description)")
                HStack {
                    Text("Break: \(self.cell.breakPoint.description)")
                    Spacer()
                    Button(
                        action: {
                            self.cell.breakPoint += 1
                        },
                        label: {
                            Image(systemName: "plus.square")
                            .modifier(BreakPointBackground(fg: .primary))
                        }
                    )
                    Button(
                        action: {
                            self.cell.breakPoint = .never
                        },
                        label: {
                            Image(systemName: "clear")
                            .modifier(BreakPointBackground(fg: .red))
                        }
                    )
                    Button(
                        action: {
                            self.cell.breakPoint -= 1
                        },
                        label: {
                            Image(systemName: "minus.square")
                            .modifier(BreakPointBackground(fg: .primary))
                        }
                    )
                }
                .foregroundColor(.primary)
            }
        }
        .font(.system(.headline, design: .monospaced))
        .padding()
        .frame(width: 350)
        .overlay(strokedRoundedRectangle(cornerRadius: 5, stroke: 2, color: .primary))
    }
}

struct CellDetail_Previews: PreviewProvider {
    static var previews: some View {
        MemoryDetail(index: 0, memory: Memory())
    }
}
