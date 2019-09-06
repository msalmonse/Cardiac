//
//  ExecUnitRun.swift
//  Cardiac
//
//  Created by Michael Salmon on 2019-09-05.
//  Copyright © 2019 mesme. All rights reserved.
//

import SwiftUI

extension ExecUnit {

    func startRunning(_ pace: Double = 1.0) {
        if runState != .running(pace) {
            clock = nil
            clock = Timer.publish(every: pace, on: .main, in: .default)
                .autoconnect()
                .sink(receiveValue: { [weak self] _ in self?.execOne() })
            runState = .running(pace)
        }
    }

    func halt(_ newState: RunState = .halted) {
        clock = nil
        runState = newState
        return
    }
}
