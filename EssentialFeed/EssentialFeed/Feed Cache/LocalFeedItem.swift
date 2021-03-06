//
//  LocalFeedItem.swift

//
//  Created by Sebastian Leon on 2/16/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import Foundation

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let imageURL: URL
    public let description: String?
    public let location: String?
    
    public init(id: UUID, imageURL: URL, description: String?, location: String?) {
        self.id = id
        self.imageURL = imageURL
        self.description = description
        self.location = location
    }
}
