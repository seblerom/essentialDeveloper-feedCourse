//
//  CodableFeedStore.swift

//
//  Created by Sebastian Leon on 2/18/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import Foundation

public final class CodableFeedStore: FeedStore {
    
    private let queue = DispatchQueue(label: "\(CodableFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        
        let storeURL = self.storeURL
        
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.found(feed: cache.localItems, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        
        let storeURL = self.storeURL
        
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = Cache(items: items.map(CodableFeedItem.init), timestamp: timestamp)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCache(completion: @escaping DeletionCompletion) {
        
        let storeURL = self.storeURL
        
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}

// MARK: - Private representations
private extension CodableFeedStore {
    
    private struct Cache: Codable {
        let items: [CodableFeedItem]
        let timestamp: Date
        
        var localItems: [LocalFeedItem] {
            items.map { $0.local }
        }
    }
    
    private struct CodableFeedItem: Codable {
        private let id: UUID
        private let imageURL: URL
        private let description: String?
        private let location: String?
        
        init(_ feed: LocalFeedItem) {
            self.id = feed.id
            self.imageURL = feed.imageURL
            self.description = feed.description
            self.location = feed.location
        }
        
        var local: LocalFeedItem {
            LocalFeedItem(
                id: id,
                imageURL: imageURL,
                description: description,
                location: location
            )
        }
    }
}
