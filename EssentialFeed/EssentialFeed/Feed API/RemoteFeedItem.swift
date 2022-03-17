//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Sebastian Leon on 3/16/22.
//

import Foundation

public struct RemoteFeedItem: Decodable {
    let id: UUID
    let image: URL
    let description: String?
    let location: String?
}
