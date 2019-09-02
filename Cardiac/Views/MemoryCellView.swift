//
//  CellView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct MemoryCellView: View {
    let index: Int
    @ObservedObject var cell: Cell

    var body: some View {
        HStack(spacing: 1) {
            if index < 0 {
                Text("")
            } else {
                Text(cell.location)
                .foregroundColor(cell.activity.color)
                .padding(3)
                Spacer()
                Text(cell.formattedValue)
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
                .padding(3)
                .overlay(strokedRoundedRectangle(cornerRadius: 2))
            }
        }
        .font(.system(.headline, design: .monospaced))
        .frame(width: 80)
        .overlay(strokedRoundedRectangle(cornerRadius: 2, stroke: 2))
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryCellView(index: 0, cell: Cell(0))
    }
}