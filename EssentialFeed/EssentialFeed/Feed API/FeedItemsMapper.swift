//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Sebastian Leon on 29.12.2021.
//

import Foundation

internal final class FeedItemsMapper {
	
	private struct Root: Decodable {
		let items: [Item]
	}

	private struct Item: Decodable {
		let id: UUID
		let image: URL
		let description: String?
		let location: String?
		
		var item: FeedItem {
			FeedItem(id: id, imageURL: image, description: description, location: location)
		}
	}
	
	private static var OK_200: Int { 200 }
	
	internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
		
		guard response.statusCode == OK_200 else {
			throw RemoteFeedLoader.Error.invalidData
		}
		
		let root = try JSONDecoder().decode(Root.self, from: data)
		return root.items.map { $0.item }
	}
	
}
