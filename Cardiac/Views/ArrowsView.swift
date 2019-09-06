//
//  ArrowsView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-05.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let dummyArrow =
    Arrow(CGPoint(x: -100, y: -100), CGPoint(x: -100, y: -200), fill: .clear)

fileprivate func drawArrow(_ arrow: ArrowData) -> some View {
    guard let startRect = Position.self[arrow.startTag] else { return dummyArrow }
    let startPoint = CGPoint(x: startRect.minX, y: startRect.midY)

    guard let stopRect = Position.self[arrow.stopTag] else { return dummyArrow }
    let stopPoint = CGPoint(x: stopRect.maxX, y: stopRect.midY)

    return Arrow(startPoint, stopPoint, fill: arrow.color)
}

struct ArrowsView: View {
    let exec: ExecUnit

    var body: some View {
        Group {
            if exec.execArrow != nil {
                drawArrow(exec.execArrow!)
            } else {
                Text("").hidden()
            }
        }
    }
}

struct ArrowsView_Previews: PreviewProvider {
    static let cpu = CPU()
    static var previews: some View {
        ArrowsView(exec: cpu.exec)
    }
}
