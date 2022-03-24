//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Sebastian Leon on 3/24/22.
//

import EssentialFeed

final class FeedImageViewModel<Image> {
    // MARK: - Type Aliases
    typealias Observer<T> = (T) -> Void
    
    // MARK: - Variables
    private var task: FeedImageDataLoaderTask?
    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    
    // MARK: - Constants
    private let model: FeedItem
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    // MARK: - Life cycle
    init(model: FeedItem, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    // MARK: - Computed variables / transformations
    var location: String? {
        model.location
    }
    
    var description: String? {
        model.description
    }
    
    var hasLocation: Bool {
        location != nil
    }
    
    // MARK: - Actions
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        task = imageLoader.loadImageData(from: model.imageURL) { [weak self] result in
            self?.handle(result)
        }
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
    
    // MARK: - Private Actions
    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
}
