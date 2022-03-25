//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedRefreshViewController: NSObject, FeedLoadingView {
    
    // MARK: - Variables
    private(set) lazy var view = loadView()
    
    // MARK: - Contants
    private let delegate: FeedRefreshViewControllerDelegate
    
    // MARK: - Life cycle
    init(delegate: FeedRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions
    func display(_ viewModel: FeedLoadingViewModel) {
        viewModel.isLoading ? view.beginRefreshing() : view.endRefreshing()
    }
    
    @objc
    func refresh() {
        delegate.didRequestFeedRefresh()
    }
    
    // MARK: - Private Actions
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
