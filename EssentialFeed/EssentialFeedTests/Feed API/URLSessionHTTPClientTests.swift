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
		session.dataTask(with: url) { _,_,_ in }.resume()
	}
	
}

class URLSessionHTTPClientTests: XCTestCase {

	func test_getFromURL_resumesDataTaskWitURL() {
		let url = URL(string: "https://any-url.com")!
		let session = URLSessionSpy()
		let task = URLSessiontDataTaskSpy()
		session.stub(url: url, task: task)
		
		let sut = URLSessionHTTPClient(session: session)
		
		sut.get(from: url)
		
		XCTAssertEqual(task.resumeCallCount, 1)
		
	}
}

// MARK: - Helpers
private extension URLSessionHTTPClientTests {
	
	class URLSessionSpy: URLSession {
		
		private var stubs = [URL: URLSessionDataTask]()
		
		func stub(url: URL, task: URLSessionDataTask) {
			stubs[url] = task
		}
		
		override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
			
			return stubs[url] ?? FakeURLSessionDataTask()
		}
		
	}
	
	class FakeURLSessionDataTask: URLSessionDataTask {
		override func resume() {}
	}
	
	class URLSessiontDataTaskSpy: URLSessionDataTask {
		
		var resumeCallCount = 0
		
		override func resume() {
			resumeCallCount += 1
		}
	}
	
}
