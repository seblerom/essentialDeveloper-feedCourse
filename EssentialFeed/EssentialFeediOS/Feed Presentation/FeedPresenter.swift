//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/24/22.
//

import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedItem]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}


final class FeedPresenter {

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
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.feedView?.display(FeedViewModel(feed: feed))
            }
            self?.loadingView?.display(FeedLoadingViewModel(isLoading: false))
        }
    }
}
