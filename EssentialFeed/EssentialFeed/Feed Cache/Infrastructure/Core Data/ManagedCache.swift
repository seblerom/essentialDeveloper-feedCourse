//
//  ManagedCache.swift

//
//  Created by Sebastian Leon on 2/24/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    var localCharacterFeed: [LocalFeedItem] {
        feed.compactMap { ($0 as? ManagedFeed)?.local }
    }
    
    static func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        // swiftlint:disable:next force_unwrapping
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(in: context).map(context.delete)
        return ManagedCache(context: context)
    }
}
