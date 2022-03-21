//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Sebastian Leon on 3/21/22.
//

import XCTest
import EssentialFeed
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadFeedCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadFeedCallCount, 3, "Expected a third loading request once user initiates another load")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completes successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completes with error")
    }
    
    func test_loadFeedCompletion_rendersSuccesfullyLoadedFeed() {
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "another location")
        let image2 = makeImage(description: "another description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    func test_feedImageView_loadsImageURLWhenVisible() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1])
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until view become visible")
        
        sut.simulateFeedImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.imageURL], "Expected first image URL requests once first view becomes visible")
        
        sut.simulateFeedImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.imageURL, image1.imageURL], "Expected second image URL requests once second view becomes visible")
    }
    
    func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1])
        
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no image URL requests until view become visible")
        
        sut.simulateFeedImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.imageURL], "Expected first image URL requests once first view becomes visible")
        
        sut.simulateFeedImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.imageURL, image1.imageURL], "Expected second image URL requests once second view becomes visible")
    }
}

// MARK: - Helpers
private extension FeedViewControllerTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(feedLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, loader)
    }
    
    func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedItem {
        FeedItem(id: UUID(), imageURL: url, description: description, location: location)
    }
    
    func assertThat(_ sut: FeedViewController, isRendering feed: [FeedItem], file: StaticString = #filePath, line: UInt = #line) {
        
        guard sut.numberOfRenderedFeedImages() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got: \(sut.numberOfRenderedFeedImages()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: FeedViewController, hasViewConfiguredFor item: FeedItem, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        
        let view = sut.feedImageView(at: index)
        
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got: \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisisble = (item.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisisble, "Expected `isShowingLocation` to be \(shouldLocationBeVisisble) for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.locationText, item.location, "Expected location text to be \(String(describing: item.location)) for image view at index \(index)", file: file, line: line)
        
        XCTAssertEqual(cell.descriptionText, item.description, "Expected description text to be \(String(describing: item.description)) for image view at index \(index)", file: file, line: line)
    }
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        
        // MARK: - FeedLoader
        private var feedRequests = [(FeedLoader.Result) -> Void]()
        
        var loadFeedCallCount: Int {
            feedRequests.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            feedRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [FeedItem] = [], at index: Int = 0) {
            feedRequests[index](.success(feed))
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            feedRequests[index](.failure(error))
        }
        
        // MARK: - FeedImageDataLoader
        private(set) var loadedImageURLs = [URL]()
        private(set) var cancelledImageURLs = [URL]()
        
        func loadImageData(from url: URL) {
            loadedImageURLs.append(url)
        }
        
        func cancelImageDataLoad(from url: URL) {
            cancelledImageURLs.append(url)
        }
    }
    
}

// MARK: - FeedViewController
private extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedFeedImages() -> Int {
        tableView.numberOfRows(inSection: feedImagesSection)
    }
    
    private var feedImagesSection: Int {
        0
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int = 0) -> FeedImageCell? {
        feedImageView(at: index) as? FeedImageCell
    }
    
    func simulateFeedImageViewNotVisible(at row: Int = 0) {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate =  tableView.delegate
        let index = IndexPath(row: row, section: feedImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    }
}

// MARK: - FeedImageCell
private extension FeedImageCell {
    var isShowingLocation: Bool {
        !locationContainer.isHidden
    }
    
    var locationText: String? {
        locationLabel.text
    }
    
    var descriptionText: String? {
        descriptionLabel.text
    }
}


// MARK: - UIRefreshControl Helper
private extension UIRefreshControl {
    
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
    
}
