//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    // MARK: - Variables
    private(set) lazy var view = loadView()
    
    // MARK: - Contants
    private let loadFeed: () -> Void
    
    // MARK: - Life cycle
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
    
    // MARK: - Actions
    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc
    func refresh() {
        loadFeed()
    }
}
