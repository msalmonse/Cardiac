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

    private func digitImage(_ digit: UInt16) -> some View {
        return Image(systemName: "\(digit % 10).square")
    }

    var body: some View {
        HStack(spacing: 1) {
            if index < 0 {
                Text("")
            } else {
                Text("\(index)")
                .multilineTextAlignment(.trailing)
                .font(.caption)
                padding(.trailing, 2)
                digitImage(cell.value/100)
                digitImage(cell.value/10)
                digitImage(cell.value)
            }
        }
        .frame(width: 80)
        .overlay(RoundedRectangle(cornerRadius: 2).stroke(lineWidth: 1))
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(index: 0, cell: Cell())
    }
}
