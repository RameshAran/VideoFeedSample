//
//  RumblTests.swift
//  RumblTests
//
//  Created by Ramesh A on 26/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import XCTest
@testable import Rumbl

class RumblTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVideoFeed() {
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: "assignment", ofType: "json") else {
            XCTFail("test file not found!")
            return
        }
        let expectation = XCTestExpectation(description: "read video feed from file")
        let videoService = VideoFeedService(filePath)
        videoService.readVideoFeedFromFile { (categoryList, error) in
            guard let videoList = categoryList else {
                XCTFail("video feed data not found")
                return
            }
            for category in videoList {
                print(category.title)
                print(category.nodes[0].video.encodeURL)
            }
            expectation.fulfill()
        }
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testThumbNailGeneration() {
        guard let url = URL(string: "https://d1104ewo8apaup.cloudfront.net/video/hevc-0/97C2CB40-7D10-4DC0-9E2D-AE8AE3910777.mp4") else {
            XCTFail("error in URL")
            return
        }
        let expectation = XCTestExpectation(description: "generating thumb-nail image from url")
        VideoThumbGenerator.generateFrom(url) { (thumbImage) in
            XCTAssertNotNil(thumbImage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
