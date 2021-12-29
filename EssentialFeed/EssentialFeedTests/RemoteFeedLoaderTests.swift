//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sebastian Leon on 29.12.2021.
//

import XCTest

class RemoteFeedLoader {
	
	func load() {
		HTTPClient.sharedInstance.get(from: URL(string: "https://a-url.com")!)
	}
}

class HTTPClient {
	
	static var sharedInstance = HTTPClient()
	
	func get(from url: URL) {}
}

class HTTPClientSpy: HTTPClient {
	override func get(from url: URL) {
		requestedURL = url
	}
	
	var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let client = HTTPClientSpy()
		HTTPClient.sharedInstance = client
		_ = RemoteFeedLoader()
		
		XCTAssertNil(client.requestedURL)
	}
	
	func test_load_requestDataFromURL() {
		let client = HTTPClientSpy()
		HTTPClient.sharedInstance = client
		let sut = RemoteFeedLoader()
		
		sut.load()
		
		XCTAssertNotNil(client.requestedURL)
		
	}

}
