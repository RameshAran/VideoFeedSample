//
//  VideoCollectionViewModel.swift
//  Rumbl
//
//  Created by Ramesh A on 28/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import Foundation
import UIKit

class VideoCollectionViewModel: NSObject {
    var nodes: [Node]
    private static var imageDict: [String: UIImage] = [String: UIImage]()
    
    func cacheImae(_ key: String) -> UIImage? {
        return VideoCollectionViewModel.imageDict[key]
    }
    
    func setCacheImage(_ image: UIImage, key: String) {
        VideoCollectionViewModel.imageDict[key] = image
    }
    
    init(_ node: [Node]) {
        self.nodes = node
        super.init()
    }
    
    public var videoCount: Int {
        return nodes.count
    }
}
