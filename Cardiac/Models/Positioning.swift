//
//  Positioning.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

typealias PositionDict = [String: CGRect]

struct Position {
    private static var positions = PositionDict()

    static subscript(_ tag: String) -> CGRect? {
        get { return positions[tag] }
        set { positions[tag] = newValue }
    }
}

struct PositionBackground: View {
    let tag: String
    let color: Color

    init(_ tag: String, color: Color = .clear) {
        self.tag = tag
        self.color = color
    }

    func setPosition(_ gp: GeometryProxy) -> Color {
        Position[tag] = gp.frame(in: .global)

        return color
    }

    var body: some View {
        GeometryReader { gp in
            Rectangle()
            .fill(self.setPosition(gp))
        }
    }
}
