//
//  CommentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI
import TextView

struct CommentLink: View {
    let comment: Comment

    var body: some View {
        NavigationLink(
            destination: CommentView(comment.lines.joined(separator: "\n")),
            label: { ButtonText("Show Comment") }
        )
        .disabled(comment.isEmpty)
    }
}

struct CommentView: View {
    let textViewState: TextViewState
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    init(_ text: String) {
        let uiFont = UIFont.systemFont(ofSize: 25)
        textViewState = TextViewState(text, font: uiFont)
            .set(.isEditable(false))
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                bgColor
                VStack {
                    Spacer()
                    TextView(self.textViewState)
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.8)
                    .clipped(antialiased: true)
                    .modifier(CardiacView.Standard())
                    Spacer()
                    Button(
                        action: { self.mode.wrappedValue.dismiss() },
                        label: { ButtonText("Dismiss", font: .title) }
                    )
                }
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView("Comment")
    }
}
