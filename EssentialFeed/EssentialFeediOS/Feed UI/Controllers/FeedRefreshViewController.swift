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
    private let presenter: FeedPresenter
    
    // MARK: - Life cycle
    init(presenter: FeedPresenter) {
        self.presenter = presenter
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
        presenter.loadFeed()
    }
}
