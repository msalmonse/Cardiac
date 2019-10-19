//
//  LoadButtons.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-03.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct LoadButtons: View {
    var cpu: CPU

    func loadResource(_ name: String) {
        switch self.cpu.loadFromResource(name) {
        case .success: break
        case .failure(let err):
            let message = errorMessage(err, "loading: '\(name)")
            MessagePublisher.publish(.error(message))
        }
    }

    var body: some View {
        HStack {
            Spacer()

            Button(
                action: { self.loadResource("nim") },
                label: { ButtonText("Load nim") }
            )

            Spacer()

            EditorLink(file: cpu.currentFile)

            Spacer()

            Button(
                action: { self.loadResource("reverse") },
                label: { ButtonText("Load reverse") }
            )

            Spacer()
        }    }
}

struct LoadButtons_Previews: PreviewProvider {
    static var previews: some View {
        LoadButtons(cpu: CPU())
    }
}
