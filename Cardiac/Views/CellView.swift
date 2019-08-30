//
//  CellView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CellView: View {
    let index: Int
    @ObservedObject var cell: Cell

    var body: some View {
        HStack(spacing: 1) {
            if index < 0 {
                Text("")
            } else {
                Text(cell.location)
                .padding(3)
                Spacer()
                Text(cell.string)
                .padding(3)
                .overlay(RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 1))
            }
        }
        .font(.system(.body, design: .monospaced))
        .frame(width: 80)
        .overlay(RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 2))
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(index: 0, cell: Cell(0))
    }
}
