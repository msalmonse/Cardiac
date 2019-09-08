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

            RunButton(exec, pace: 3.0)
            RunButton(exec, pace: 1.2)

            Button(
                action: { self.exec.showArrows.toggle() },
                label: { ButtonText(self.exec.showArrows ? "Hide Arrows" : "Show Arrows") }
            )

            CommentLink(comment: exec.comment)

        }
        .padding(2)
    }
}

struct RunButton: View {
    @ObservedObject var exec: ExecUnit
    let pace: Double
    let label: String

    init(_ exec: ExecUnit, pace: Double) {
        self.exec = exec
        self.pace = pace
        self.label = String(format: "Run (%.0f ips)", 60/pace)
    }

    var body: some View {
        Group {
            if exec.runState == .running(pace) {
                Button(
                    action: { self.exec.halt() },
                    label: { ButtonText("Stop running") }
                )
            } else {
                Button(
                    action: { self.exec.startRunning(self.pace) },
                    label: { ButtonText(label) }
                )
            }
        }
    }
}

struct ExecView_Previews: PreviewProvider {
    static let cpu = CPU()
    static var previews: some View {
        ExecView(exec: cpu.exec)
    }
}
