//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sebastian Leon on 29.12.2021.
//

import XCTest

class RemoteFeedLoader {
	
	
}

class HTTPClient {
	
	var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let client = HTTPClient()
		_ = RemoteFeedLoader()
		
		XCTAssertNil(client.requestedURL)
	}

}
