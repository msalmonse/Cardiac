//
//  MessagePublisher.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-10.
//  Copyright © 2019 mesme. All rights reserved.
//

import Combine

enum MessageType {
    case error(Message)
    case message(Message)
}

struct MessagePublisher {
    static let errors = PassthroughSubject<Message, Never>()
    static let messages = PassthroughSubject<Message, Never>()

    static func publish(_ envelope: MessageType) {
        switch envelope {
        case let .error(msg): errors.send(msg)
        case let .message(msg): messages.send(msg)
        }
    }
}
