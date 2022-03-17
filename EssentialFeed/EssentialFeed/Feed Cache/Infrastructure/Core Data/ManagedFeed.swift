//
//  ManagedFeed.swift

//
//  Created by Sebastian Leon on 2/24/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import CoreData

@objc(ManagedFeed)
class ManagedFeed: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var url: URL
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    
    @NSManaged var cache: ManagedCache
    
}

extension ManagedFeed {
    
    static func characters(from localCharacterFeed: [LocalFeedItem], in context: NSManagedObjectContext) -> NSOrderedSet {
        
        NSOrderedSet(array: localCharacterFeed.map { local in
            
            let managedFeed = ManagedFeed(context: context)
            managedFeed.id = local.id
            managedFeed.url = local.imageURL
            managedFeed.imageDescription = local.description
            managedFeed.location = local.location
            
            return managedFeed
        })
    }
    
    var local: LocalFeedItem {
        LocalFeedItem(
            id: id,
            imageURL: url,
            description: imageDescription,
            location: location
        )
    }
}
