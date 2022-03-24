//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit

public final class FeedRefreshViewController: NSObject {
    
    // MARK: - Variables
    private(set) lazy var view = binded(UIRefreshControl())
    
    // MARK: - Contants
    private let viewModel: FeedViewModel
    
    // MARK: - Life cycle
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Actions
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
    
    @objc
    func refresh() {
        viewModel.loadFeed()
    }
}
