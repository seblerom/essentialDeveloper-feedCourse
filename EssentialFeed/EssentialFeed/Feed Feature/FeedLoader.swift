//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Sebastian Leon on 29.12.2021.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedItem], Error>

public protocol FeedLoader {
	func load(completion: @escaping (LoadFeedResult) -> Void)
}
