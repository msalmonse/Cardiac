//
//  CommentView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-04.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct CommentView: View {
    let comment: Comment
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            bgColor
            VStack {
                ScrollView {
                    ForEach(comment.lines, id: \.self) { line in
                        Text(line)
                    }
                }
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
        CommentView(comment: Comment())
    }
}
