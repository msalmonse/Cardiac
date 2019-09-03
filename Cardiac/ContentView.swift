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
                    VStack {
                        Text("Out")
                        TapeView(tape: cpu.outTape)
                    }
                    .modifier(Standard())

                    VStack {
                        Spacer()

                        VStack {
                            Text("Arithmatic Unit")
                            ALUview(alu: cpu.exec.alu)
                        }
                        .modifier(Standard())

                        Spacer()

                        VStack {
                            Text("Execution Unit")
                            ExecView(exec: cpu.exec)
                        }
                        .modifier(Standard())

                        Spacer()
                    }
                    .frame(width: 200)

                    VStack {
                        Text("In")
                        TapeView(tape: cpu.inTape)
                    }
                    .modifier(Standard())

                    VStack {
                        Text("Memory")
                        MemoryView(memory: cpu.memory)
                        .modifier(Standard())

                        LoadButtons(cpu: cpu)
                    }
                    .modifier(Standard())
                }
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
