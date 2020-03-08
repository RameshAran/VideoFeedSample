//
//  VideoFeedService.swift
//  Rumbl
//
//  Created by Ramesh A on 26/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import Foundation

class VideoFeedService: NSObject {
    
    typealias FeedCompletion = (_ model: VideoCategoryList?, _ error: Error?) -> Void
    // File path
    var path: String
    init(_ path: String) {
        self.path = path
        super.init()
    }
    
    func readVideoFeedFromFile(completion: @escaping FeedCompletion) {
        let fileUrl = URL(fileURLWithPath: path)
        // Getting data from JSON file using the file URL
        guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError("Failed to load \(fileUrl) from bundle.")
        }
        guard let decoder = try? JSONDecoder().decode(VideoCategoryList.self, from: data) else {
            fatalError("Failed to parse video feed")
        }
        completion(decoder, nil)
    }
}
