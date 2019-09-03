//
//  ExecView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct ExecView: View {
    @ObservedObject var exec: ExecUnit

    var body: some View {
        VStack {
            HStack {
                Text("Executing")
                Spacer()
                Text(String(format: "%02d", Int(exec.intAddress)))
            }
            Text(instruction(exec.opcode))
            Button(
                action: { self.exec.execOne() },
                label: { ButtonText("Single Step") }
            )
        }
        .padding(2)
    }
}

struct ExecView_Previews: PreviewProvider {
    static var previews: some View {
        ExecView(exec: ExecUnit(memory: Memory(), inTape: Tape(.input), outTape: Tape(.output)))
    }
}
