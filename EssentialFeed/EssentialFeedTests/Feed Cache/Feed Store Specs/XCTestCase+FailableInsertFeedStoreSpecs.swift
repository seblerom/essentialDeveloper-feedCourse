//
//  XCTestCase+FailableInsertFeedStoreSpecs.swift
//
//  Created by Sebastian Leon on 2/21/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import XCTest
import EssentialFeed

extension FailableInsertFeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueItems().local, Date()), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueItems().local, Date()), to: sut)
        
        expect(sut, toRetrieve: .success(.empty), file: file, line: line)
    }
}
