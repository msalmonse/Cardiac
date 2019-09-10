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

    var body: some View {
        NavigationView {
            ZStack {
                bgColor
                CardiacView(cpu: cpu)
                Alerts()
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
