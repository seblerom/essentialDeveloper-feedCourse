//
//  CoreDataFeedStore.swift

//
//  Created by Sebastian Leon on 2/23/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func deleteCache(completion: @escaping DeletionCompletion) {
        
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context)
                    .map(context.delete)
                    .map(context.save)
            })
        }
    }
    
    public func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeed.feed(from: items, in: context)
                
                try context.save()
            })
        }
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        
       perform { context in
           completion(Result {
               try ManagedCache.find(in: context).map {
                   return CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
               }
           })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        
        let context = self.context
        context.perform { action(context) }
    }
}
