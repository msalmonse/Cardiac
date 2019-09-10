//
//  Alerts.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

struct Alerts: View {
    @State var alert: Message? = nil

    var body: some View {
        VStack {
            Text("").hidden()
            .alert(item: $alert) { msg in
                Alert(
                    title: Text(msg.subject ?? "Alert"),
                    message: Text(msg.text),
                    dismissButton: .default(Text("Dismiss"))
                )
            }

            Text("").hidden()
            .onReceive(MessagePublisher.errors, perform: { self.alert = $0 })
        }
    }
}

struct Alerts_Previews: PreviewProvider {
    static var previews: some View {
        Alerts()
    }
}
