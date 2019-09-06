//
//  ALUview.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-02.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate var signImage: [ALU.PlusMinus: String] = [
    .nosign: "square",
    .plus: "plus.square",
    .minus: "minus.square"
]

struct ALUview: View {
    @ObservedObject var alu: ALU

    var body: some View {
        VStack {
            ALUregister(reg: alu.opA, label: "Operand A", sign: { self.alu.opAsign })
            ALUregister(reg: alu.opB, label: "Operand B", sign: { self.alu.operation })
            ALUregister(reg: alu.result, label: "Result", sign: { self.alu.sign })
        }
        .padding(3)
    }
}

struct ALUregister: View {
    @ObservedObject var reg: Cell
    let label: String
    let sign: () -> ALU.PlusMinus

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: signImage[sign()] ?? "square")
            Text(reg.formattedValue)
            .multilineTextAlignment(.trailing)
            .font(.system(.headline, design: .monospaced))
        }
    }
}

struct ALUview_Previews: PreviewProvider {
    static var previews: some View {
        ALUview(alu: ALU())
    }
}
