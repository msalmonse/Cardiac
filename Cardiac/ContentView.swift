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
        ZStack {
            Color(hue: 0.4, saturation: 0.1, brightness: 1.0)
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
                MemoryView(memory: cpu.memory)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                    .stroke(lineWidth: 3.0)
                    .foregroundColor(.green)
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
