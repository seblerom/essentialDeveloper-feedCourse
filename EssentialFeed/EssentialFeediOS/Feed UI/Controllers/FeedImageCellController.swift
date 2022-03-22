//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/22/22.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
    
    // MARK: - Variables
    private var task: FeedImageDataLoaderTask?
    // MARK: - Constants
    private let model: FeedItem
    private let imageLoader: FeedImageDataLoader
    
    // MARK: - Life cycle
    init(model: FeedItem, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    deinit {
        task?.cancel()
    }
    
    // MARK: - Actions
    func view() -> UITableViewCell {

        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (model.location == nil)
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageView.image = nil
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self = self else {
                return
            }
            
            self.task = self.imageLoader.loadImageData(from: self.model.imageURL) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil)
                cell?.feedImageContainer.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.imageURL) { _ in }
    }
}
