//
//  VideoThumbGenerator.swift
//  Rumbl
//
//  Created by Ramesh A on 29/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit
import AVFoundation

class VideoThumbGenerator: NSObject {
    typealias ThumbCompletion = (_ image: UIImage?) -> Void
    
    class func generateFrom(_ url: URL, completion: @escaping ThumbCompletion) {
        DispatchQueue.global(qos: .userInteractive).async {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.maximumSize = CGSize(width: 120, height: 155)
            let time = CMTimeMake(value: 1, timescale: 1)
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let thumb = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(thumb)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
