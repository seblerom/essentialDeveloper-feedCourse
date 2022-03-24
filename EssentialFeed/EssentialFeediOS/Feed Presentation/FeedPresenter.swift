//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/24/22.
//

import EssentialFeed

protocol FeedView {
    func display(feed: [FeedItem])
}

protocol FeedLoadingView {
    func display(isLoading: Bool)
}

final class FeedPresenter {
    // MARK: - Type aliases
    typealias Observer<T> = (T) -> Void
    // MARK: - Constants
    private let feedLoader: FeedLoader
    
    // MARK: - Variables
    var feedView: FeedView?
    var loadingView: FeedLoadingView?
    
    // MARK: - Life cycle
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // MARK: - Actions
    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
