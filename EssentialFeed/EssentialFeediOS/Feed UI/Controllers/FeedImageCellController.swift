//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {

    // MARK: - Variables
    private lazy var cell = FeedImageCell()
    // MARK: - Constants
    private let delegate: FeedImageCellControllerDelegate
    
    // MARK: - Life cycle
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
        
    // MARK: - Actions
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
    
    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        
        cell.locationContainer.isHidden = !viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.feedImageView.image = viewModel.image
        cell.feedImageContainer.isShimmering = viewModel.isLoading
        cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        cell.onRetry = delegate.didRequestImage
    }
    
}
