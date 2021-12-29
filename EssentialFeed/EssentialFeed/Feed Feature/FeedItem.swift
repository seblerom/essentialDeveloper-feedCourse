//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Sebastian Leon on 29.12.2021.
//

import Foundation

public struct FeedItem: Equatable {
	let id: UUID
	let iamgeURL: URL
	let description: String?
	let location: String?
}
