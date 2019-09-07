//
//  Arrow.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-05.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct ArrowData {
    let startTag: String
    let stopTag: String
    let color: Color

    init(_ start: String, _ stop: String, _ color: Color) {
        self.startTag = start
        self.stopTag = stop
        self.color = color
    }
}

enum ArrowError: Error {
    case noArrow, noPoint
}

extension ArrowError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noArrow: return "There is no arrow defined"
        case .noPoint: return "The point is not defined"
        }
    }
}

fileprivate let delta: CGFloat = 3.0
fileprivate let delta2 = delta + delta
fileprivate let delta3 = delta2 + delta
fileprivate let delta4 = delta3 + delta

fileprivate let circleRect = CGRect(
    origin: CGPoint(x: -delta2, y: -delta2),
    size: CGSize(width: delta4, height: delta4)
)

struct Arrow: View {
    let start: CGPoint
    let stop: CGPoint
    let fill: Color
    let length: CGFloat
    let transform: CGAffineTransform

    init(_ start: CGPoint, _ stop: CGPoint, fill: Color) {
        self.start = start
        self.stop = stop
        self.fill = fill

        let deltaX = stop.x - start.x
        let deltaY = stop.y - start.y

        length = sqrt(deltaX * deltaX + deltaY * deltaY)
        let sinTransform = -deltaX/length
        let cosTransform = deltaY/length

        transform = CGAffineTransform(
            a: cosTransform,
            b: sinTransform,
            c: -sinTransform,
            d: cosTransform,
            tx: start.x,
            ty: start.y
        )
    }

    var body: some View {
        Path { path in
            path.addEllipse(in: circleRect)

            path.move(to: CGPoint(x: -delta, y: delta2))
            path.addLine(to: CGPoint(x: -delta, y: length - delta3))
            path.addLine(to: CGPoint(x: -delta4, y: length - delta4))
            path.addLine(to: CGPoint(x: 0.0, y: length))
            path.addLine(to: CGPoint(x: delta4, y: length - delta4))
            path.addLine(to: CGPoint(x: delta, y: length - delta3))
            path.addLine(to: CGPoint(x: delta, y: delta2))
        }
        .transform(transform)
        .fill(fill)
    }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow(CGPoint(x: 100, y: 100), CGPoint(x: 256, y: 512), fill: .red)
    }
}
