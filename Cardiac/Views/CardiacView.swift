//
//  CardiacView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CardiacView: View {
    let cpu: CPU

    func strokedStandard() -> some View {
        return strokedRoundedRectangle(cornerRadius: 3, stroke: 3, color: .green)
    }

    struct Heading: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.horizontal, 2)
                .overlay(strokedRoundedRectangle(cornerRadius: 2, stroke: 2, color: .green))
        }
    }

    struct Standard: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding(.all, 12)
                .overlay(strokedRoundedRectangle(cornerRadius: 3, stroke: 3, color: .green))
                .padding(.horizontal, 10)
        }
    }

    var body: some View {
        HStack {
            TapeOutView(tape: cpu.outTape)
            .modifier(Standard())
            .padding(.vertical, 8)

            VStack {
                Spacer()

                VStack {
                    Text("Arithmatic Unit").modifier(Heading())
                    ALUview(alu: cpu.exec.alu)
                }
                .modifier(Standard())
                .background(PositionBackground("Arithmatic Unit"))

                Spacer()

                VStack {
                    Text("Execution Unit").modifier(Heading())
                    ExecView(exec: cpu.exec)
                }
                .modifier(Standard())
                .background(PositionBackground("Execution Unit"))

                Spacer()
            }
            .frame(width: 225)

            TapeInView(tape: cpu.inTape)
            .modifier(Standard())
            .padding(.vertical, 8)

            VStack {
                Text("Memory").modifier(Heading())
                MemoryView(memory: cpu.memory)
                .modifier(Standard())

                LoadButtons(cpu: cpu)
            }
            .modifier(Standard())
        }
    }
}

struct CardiacView_Previews: PreviewProvider {
    static var previews: some View {
        CardiacView(cpu: CPU())
    }
}
