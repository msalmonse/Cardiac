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
                Text(exec.runDescription)
                Spacer()
                Text(String(format: "@%02d", Int(exec.intAddress)))
            }

            Text(instruction(exec.opcode))

            Button(
                action: { self.exec.execOne(true) },
                label: { ButtonText("Single Step") }
            )

            Button(
                action: { self.exec.startRunning(3.0) },
                label: { ButtonText("Run (20 ips)") }
            )

            CommentLink(comment: exec.comment)

        }
        .padding(2)
    }
}

struct ExecView_Previews: PreviewProvider {
    static let cpu = CPU()
    static var previews: some View {
        ExecView(exec: cpu.exec)
    }
}
