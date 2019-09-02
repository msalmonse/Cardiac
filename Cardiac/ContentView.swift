//
//  ContentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var cpu = CPU()

    var body: some View {
        NavigationView {
            ZStack {
                Color(hue: 0.4, saturation: 0.1, brightness: 1.0)
                HStack {
                    TapeView(tape: cpu.outTape)
                    VStack {
                        Spacer()
                        ALUview(alu: cpu.alu)
                        .overlay(strokedRoundedRectangle(cornerRadius: 3, stroke: 3, color: .green))
                        .frame(width: 200)
                        Spacer()
                        Button(
                            action: { self.cpu.execOne() },
                            label: { Text("Exec 1") }
                        )
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
                        Spacer()
                    }
                    TapeView(tape: cpu.inTape)
                    Spacer()
                    MemoryView(memory: cpu.memory)
                    .overlay(strokedRoundedRectangle(cornerRadius: 3, stroke: 3, color: .green))
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
