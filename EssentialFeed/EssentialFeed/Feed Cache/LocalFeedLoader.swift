//
//  LocalFeedLoader.swift

//
//  Created by Sebastian Leon on 2/16/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
}

public extension LocalFeedLoader {
    
    typealias SaveResult = Error?
    
    func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
        
        store.deleteCache { [weak self] error in
            
            guard let self = self else {
                return
            }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping (SaveResult) -> Void) {
        
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else {
                return
            }
            completion(error)
        }
    }
}

extension LocalFeedLoader: FeedLoader {
    
    public typealias LoadResult = FeedLoader.Result
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        
        store.retrieve { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
            
            case let .success(.found(feed, timestamp)) where FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
                
            case .success:
                completion(.success([]))
            }
        }
    }
}

public extension LocalFeedLoader {
    
    func validateCache() {
        store.retrieve { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            switch result {
            case .failure:
                self.store.deleteCache { _ in }
                
            case let .success(.found(_, timestamp)) where !FeedCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCache { _ in }
                
            case .success:
                break
            }
        }
    }
}

private extension Array where Element == FeedItem {
    
    func toLocal() -> [LocalFeedItem] {
        map {
            LocalFeedItem(
                id: $0.id,
                imageURL: $0.imageURL,
                description: $0.description,
                location: $0.location
            )
        }
    }
}

private extension Array where Element == LocalFeedItem {
    
    func toModels() -> [FeedItem] {
        map {
            FeedItem(
                id: $0.id,
                imageURL: $0.imageURL,
                description: $0.description,
                location: $0.location
            )
        }
    }
}
