//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import EssentialFeed

final class FeedViewModel {
    // MARK: - Type aliases
    typealias Observer<T> = (T) -> Void
    // MARK: - Constants
    private let feedLoader: FeedLoader
    
    // MARK: - Variables
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[FeedItem]>?
    
    // MARK: - Life cycle
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // MARK: - Actions
    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
