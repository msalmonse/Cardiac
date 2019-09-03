//
//  ButtonLabel.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-03.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

fileprivate let saturations = [ 0.0, 0.15, 0.20, 0.25, 0.30, 0.30, 0.30, 0.35, 0.40, 0.45, 0.60  ]

fileprivate let linearDark = LinearGradient(
    gradient: Gradient(colors: saturations.map {
            Color(hue: bgHue, saturation: $0, brightness: 0.67)
        }
    ),
    startPoint: .top,
    endPoint: .bottom
)

fileprivate let linearLight = LinearGradient(
    gradient: Gradient(colors: saturations.map {
            Color(hue: bgHue, saturation: $0, brightness: 1.0)
        }
    ),
    startPoint: .top,
    endPoint: .bottom
)

struct ButtonBackground: ViewModifier {
    let font: Font

    func padBy() -> CGFloat {
        switch font {
        case .largeTitle: return 15
        default: return 8
        }
    }

    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(font)
            .padding(.all, padBy())
            .background(linearLight)
            .clipShape(Capsule())
            .overlay(strokedCapsule(stroke: 1, color: .green))
            .padding(2)
    }
}

struct ButtonText: View {
    let text: String
    let font: Font

    init(_ text: String, font: Font = .headline) {
        self.text = text
        self.font = font
    }

    var body: some View {
        Text(text)
        .modifier(ButtonBackground(font: font))
    }
}

struct ButtonImage: View {
    let name: String
    let font: Font

    init(systemName: String, font: Font = .headline) {
        name = systemName
        self.font = font
    }

    var body: some View {
        Image(systemName: name)
        .modifier(ButtonBackground(font: font))
    }
}

struct ButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonText("Dismiss")
            ButtonImage(systemName: "chevron.up.circle.fill")
        }
    }
}
