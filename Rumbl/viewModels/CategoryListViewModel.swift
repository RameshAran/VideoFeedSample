//
//  CategoryListViewModel.swift
//  Rumbl
//
//  Created by Ramesh A on 26/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import Foundation

class CategoryListViewModel: NSObject {
    
    var categoryList: VideoCategoryList = [VideoCategoryElement]()
    
    public var categoryCount: Int {
        return categoryList.count
    }
    
    func fetchVideoFeed(completion: @escaping (Bool) -> Void) {
        guard let path: String = Bundle.main.path(forResource: "assignment", ofType: "json") else {
            // Sending empty list
            completion(false)
            return
        }
        let videoService = VideoFeedService(path)
        videoService.readVideoFeedFromFile { (videoList, error) in
            guard let list = videoList else {
                completion(false)
                return
            }
            self.categoryList = list
            completion(true)
        }
    }
}
