//
//  ExecView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct ExecView: View {
    @ObservedObject var cpu: CPU

    var body: some View {
        VStack {
            HStack {
                Text("Executing")
                Spacer()
                Text(String(format: "%02d", Int(cpu.execAddr)))
            }
            Text(instruction(cpu.memory[cpu.execAddr]))
            Button(
                action: { self.cpu.execOne() },
                label: { Text("Exec 1") }
            )

        }
    }
}

struct ExecView_Previews: PreviewProvider {
    static var previews: some View {
        ExecView(cpu: CPU())
    }
}
