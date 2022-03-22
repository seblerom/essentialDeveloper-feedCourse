//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit
import EssentialFeed

public final class FeedRefreshViewController: NSObject {
    
    // MARK: - Variables
    var onRefresh: (([FeedItem]) -> Void)?
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    // MARK: - Constants
    private let feedLoader: FeedLoader
    
    // MARK: - Life cycle
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // MARK: - Actions
    @objc
    func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            
            self?.view.endRefreshing()
        }
    }
}
