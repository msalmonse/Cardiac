//
//  CommentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CommentLink: View {
    @ObservedObject var exec: ExecUnit

    var body: some View {
        NavigationLink(
            destination: CommentView(comment: exec.comment),
            label: { ButtonText("Show Comment") }
        )
        .disabled(exec.comment.isEmpty)
    }
}

struct CommentView: View {
    let comment: Comment
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            bgColor
            VStack {
                ForEach(comment.lines, id: \.self) { line in
                    Text(line)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.primary)
                }
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
