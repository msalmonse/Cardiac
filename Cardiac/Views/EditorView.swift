//
//  EditorView.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-24.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI
import UIKit
import TextView

let reverse = """
# Reverse

   loc 15
start: inp input  # Read 'abc'
   cla input
   slr 3 1        # Shift to produce 'c00'
   sto output
   cla input
   slr 1 3        # Shift to produce '00a'
   add output     # Produce 'c0a'
   sto output
   cla input
   slr 2 3        # Shift to produce '00b'
   slr 1 0        # Shift to produce '0b0'
   add output     # Produce 'cba'
   sto output
   out output
   hrs start
   tape 123   # Test value
input: bss 1
output: bss 1
comment
Reverse the number read from the input i.e. 123 becomes 321
endcomment
"""

struct EditorLink: View {
    let text: String

    var body: some View {
        NavigationLink(
            destination: EditorView(reverse),
            label: { ButtonText("Show Editor") }
        )
    }
}

struct EditorView: View {
    let textViewState: TextViewState
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    init(_ text: String) {
        let uiFont = UIFont.monospacedSystemFont(ofSize: 25, weight: .regular)
        textViewState = TextViewState(text, font: uiFont)
            .set(.autocapitalizationType(.none))
            .set(.autocorrectionType(.no))
            .set(.spellCheckingType(.no))
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

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView("Editor")
    }
}
