//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import EssentialFeed

final class FeedViewModel {
    // MARK: - Constants
    private let feedLoader: FeedLoader
    
    // MARK: - Variables
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedItem]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    // MARK: - Life cycle
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // MARK: - Actions
    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
