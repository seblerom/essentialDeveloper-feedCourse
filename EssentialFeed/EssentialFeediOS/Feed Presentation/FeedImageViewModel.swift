//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/24/22.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        location != nil
    }
}
