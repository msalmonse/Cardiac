//
//  ArrowsView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-05.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let dummyArrow =
    Arrow(CGPoint(x: -100, y: -100), CGPoint(x: -200, y: -200), fill: .clear)

fileprivate func drawArrow(_ arrow: ArrowData?) -> some View {
    if arrow == nil { return dummyArrow }
    guard let startRect = Position.self[arrow!.startTag] else { return dummyArrow }
    guard let stopRect = Position.self[arrow!.stopTag] else { return dummyArrow }

    let rtl = startRect.midX > stopRect.midX
    let startPoint = CGPoint(x: rtl ? startRect.minX : startRect.maxX, y: startRect.midY)
    let stopPoint = CGPoint(x: rtl ? stopRect.maxX : stopRect.minX, y: stopRect.midY)
    return Arrow(startPoint, stopPoint, fill: arrow!.color)
}

struct ArrowsView: View {
    @ObservedObject var exec: ExecUnit

    var body: some View {
        ZStack {
            drawArrow(exec.execArrow)
            drawArrow(exec.readArrow)
            drawArrow(exec.writeArrow)
        }
    }
}

struct ArrowsView_Previews: PreviewProvider {
    static let cpu = CPU()
    static var previews: some View {
        ArrowsView(exec: cpu.exec)
    }
}
