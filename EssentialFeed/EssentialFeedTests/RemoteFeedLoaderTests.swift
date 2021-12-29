//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sebastian Leon on 29.12.2021.
//

import XCTest

class RemoteFeedLoader {
	
	func load() {
		HTTPClient.sharedInstance.requestedURL = URL(string: "https://a-url.com")
	}
}

class HTTPClient {
	
	static let sharedInstance = HTTPClient()
	
	private init() {}
	
	var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let client = HTTPClient.sharedInstance
		_ = RemoteFeedLoader()
		
		XCTAssertNil(client.requestedURL)
	}
	
	func test_load_requestDataFromURL() {
		
		let client = HTTPClient.sharedInstance
		let sut = RemoteFeedLoader()
		
		sut.load()
		
		XCTAssertNotNil(client.requestedURL)
		
	}

}
