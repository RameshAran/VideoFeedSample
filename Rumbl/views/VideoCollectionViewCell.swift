//
//  VideoCollectionViewCell.swift
//  Rumbl
//
//  Created by Ramesh A on 29/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    var representedId: String?
    
    var image: UIImage? {
        didSet {
            thumbImageView.image = image
        }
    }
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        thumbImageView.clipsToBounds = true
        thumbImageView.layer.cornerRadius = 12
        //thumbImageView.image = UIImage(named: "placeholder")
        super.awakeFromNib()
    }
}
