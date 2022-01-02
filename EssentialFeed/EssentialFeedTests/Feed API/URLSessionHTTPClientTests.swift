//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Sebastian Leon on 02.01.2022.
//

import XCTest

class URLSessionHTTPClient {
	
	private let session: URLSession
	
	init(session: URLSession) {
		self.session = session
	}
	
	func get(from url: URL) {
		session.dataTask(with: url) { _,_,_ in }
	}
	
}

class URLSessionHTTPClientTests: XCTestCase {

	func test_getFromURL_createsDataTaskWitURL() {
		let url = URL(string: "https://any-url.com")!
		let session = URLSessionSpy()
		let sut = URLSessionHTTPClient(session: session)
		
		sut.get(from: url)
		
		XCTAssertEqual(session.receivedURLs, [url])
		
	}
}

// MARK: - Helpers
private extension URLSessionHTTPClientTests {
	
	class URLSessionSpy: URLSession {
		
		var receivedURLs = [URL]()
		
		override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
			
			receivedURLs.append(url)
			
			return FakeURLSessionDataTask()
		}
		
	}
	
	class FakeURLSessionDataTask: URLSessionDataTask {}
	
}
