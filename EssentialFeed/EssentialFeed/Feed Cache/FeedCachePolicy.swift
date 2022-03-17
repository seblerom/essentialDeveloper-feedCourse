//
//  FeedCachePolicy.swift

//
//  Created by Sebastian Leon on 2/17/22.
//  Copyright © 2022 STRV. All rights reserved.
//

import Foundation

enum FeedCachePolicy {
    
    private static let calendar = Calendar(identifier: .gregorian)
    private static var maxCacheAgeInDays: Int { 7 }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        
        return date < maxCacheAge
    }
}
