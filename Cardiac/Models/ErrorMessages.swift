//
//  ErrorMessages.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Foundation

/// Return the description of an error

func errorText(_ err: Error) -> String {
    return err.localizedDescription
}

/// The error description in a message

func errorMessage(_ err: Error, _ location: String) -> Message {
    let subject = "Error " + location
    return Message(errorText(err), subject: subject)
}
