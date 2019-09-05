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
        ZStack {
            bgColor
            VStack {
                Spacer()

                ForEach(comment.lines, id: \.self) { line in
                    Text(line)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(5)
                }
                .foregroundColor(.primary)
                .background(Color(.systemBackground))
                .modifier(ContentView.Standard())

                Spacer()

                Button(
                    action: { self.mode.wrappedValue.dismiss() },
                    label: { ButtonText("Dismiss", font: .title) }
                )
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: Comment("Comment"))
    }
}