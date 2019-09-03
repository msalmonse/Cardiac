//
//  ContentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

let bgColor = Color(hue: 0.4, saturation: 0.1, brightness: 1.0)

struct ContentView: View {
    var cpu = CPU()

    func strokedStandard() -> some View {
        return strokedRoundedRectangle(cornerRadius: 3, stroke: 3, color: .green)
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
                    .overlay(strokedStandard())
                    .frame(width: 200)

                    VStack {
                        Spacer()

                        ALUview(alu: cpu.exec.alu)
                        .overlay(strokedStandard())
                        .frame(width: 200)

                        Spacer()

                        ExecView(exec: cpu.exec)
                        .overlay(strokedStandard())
                        .frame(width: 200)

                        Spacer()
                    }

                    VStack {
                        Text("In")
                        TapeView(tape: cpu.inTape)
                    }
                    .overlay(strokedStandard())
                    .frame(width: 200)

                    Spacer()

                    VStack {
                        Text("Memory")
                        MemoryView(memory: cpu.memory)
                        .overlay(strokedStandard())

                        HStack {
                            Button(
                                action: {
                                    switch self.cpu.loadJsonResource("nim") {
                                    case .success: break
                                    case .failure(let err): print(err)
                                    }
                                },
                                label: { Text("Load nim") }
                            )
                            Button(
                                action: {
                                    switch self.cpu.loadJsonResource("reverse") {
                                    case .success: break
                                    case .failure(let err): print(err)
                                    }
                                },
                                label: { Text("Load reverse") }
                            )
                        }
                    }
                    .overlay(strokedStandard())
                    .frame(width: 200)

                    Spacer()
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
