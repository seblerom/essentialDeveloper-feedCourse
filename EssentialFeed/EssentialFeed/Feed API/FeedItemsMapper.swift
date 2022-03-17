//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Sebastian Leon on 29.12.2021.
//

import Foundation

internal final class FeedItemsMapper {
	
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var validStatusCode: Int { 200 }
	
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        
        guard
            response.statusCode == validStatusCode,
            let root = try? JSONDecoder().decode(Root.self, from: data)
        else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
