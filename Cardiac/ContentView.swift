//
//  ContentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

let bgHue = 0.4
let bgColor = Color(hue: bgHue, saturation: 0.1, brightness: 1.0)

struct ContentView: View {
    var cpu = CPU()

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
        NavigationView {
            ZStack {
                bgColor
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

                        Spacer()

                        VStack {
                            Text("Execution Unit").modifier(Heading())
                            ExecView(exec: cpu.exec)
                        }
                        .modifier(Standard())

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
                ArrowsView(exec: cpu.exec)
            }
            .navigationBarHidden(true)
            .navigationBarTitle(Text("Cardiac"), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
