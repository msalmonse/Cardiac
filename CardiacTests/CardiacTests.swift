//
//  CardiacTests.swift
//  CardiacTests
//
//  Created by Michael Salmon on 2019-08-29.
//  Copyright © 2019 mesme. All rights reserved.
//

import XCTest
@testable import Cardiac

class CardiacTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJsonLoad() {
        let cpu = CPU()

        switch cpu.loadJsonResource("reverse") {
        case .success: break
        case .failure(let err): XCTAssert(false, err.localizedDescription)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
