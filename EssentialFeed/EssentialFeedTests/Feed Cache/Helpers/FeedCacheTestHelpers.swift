//
//  FeedCacheTestHelpers.swift
//
//  Created by Sebastian Leon on 2/16/22.
//  Copyright © 2022 STRV. All rights reserved.
//

// swiftlint:disable force_unwrapping
import Foundation
import EssentialFeed

func uniqueItem() -> FeedItem {
    FeedItem(
        id: UUID(),
        imageURL: anyURL(),
        description: "any description",
        location: "any location"
    )
}

func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
    let models = [uniqueItem(), uniqueItem()]
    let local =  models.map {
        LocalFeedItem(
            id: $0.id,
            imageURL: $0.imageURL,
            description: $0.description,
            location: $0.location
        )
    }
    return (models, local)
}

extension Date {
    
    private var characterCacheMaxAgeInDays: Int { 7 }
    
    func minusCharacterCacheMaxAge() -> Date {
        return adding(days: -characterCacheMaxAgeInDays)
    }
    
    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
}
