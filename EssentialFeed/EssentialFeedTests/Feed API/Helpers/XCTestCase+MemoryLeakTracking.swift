//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by Sebastian Leon on 2/8/22.
//

import XCTest

extension XCTestCase {
    func trackFromMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
    
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should've been deallocated, potential memory leak", file: file, line: line)
        }
    }
}
