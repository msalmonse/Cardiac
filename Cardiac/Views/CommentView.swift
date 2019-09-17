//
//  CommentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CommentLink: View {
    let comment: Comment

    var body: some View {
        NavigationLink(
            destination: CommentView(comment: comment),
            label: { ButtonText("Show Comment") }
        )
        .disabled(comment.isEmpty)
    }
}

struct CommentView: View {
    let comment: Comment
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                bgColor
                VStack {
                    Spacer()
                    ScrollView {
                        Text(self.comment.lines.joined(separator: "\n"))
                        .foregroundColor(.primary)
                        .background(Color(.systemBackground))
                        .lineLimit(1000)
                        .font(.title)
                    }
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.height * 0.66)
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
        CommentView(comment: Comment("Comment"))
    }
}
