//
//  CategoryTableViewCell.swift
//  Rumbl
//
//  Created by Ramesh A on 26/02/20.
//  Copyright © 2020 Ramesh A. All rights reserved.
//

import UIKit

protocol CategoryTableViewCellDelegate: AnyObject {
    func didSelectNodes(_ nodes: [Node], at index: Int)
}

class CategoryTableViewCell: UITableViewCell {
    
    var collectionViewModel: VideoCollectionViewModel?
    weak var delegate: CategoryTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModel?.videoCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_view_video_cell", for: indexPath) as! VideoCollectionViewCell
        guard let urlString = collectionViewModel?.nodes[indexPath.row].video.encodeURL else {
            return cell
        }
        guard let url = URL(string: urlString) else {
            return cell
        }
        let cacheName = "\(urlString)"
        cell.representedId = cacheName
        if let cacheImage: UIImage = collectionViewModel?.cacheImae(cacheName) {
            cell.image = cacheImage
        } else {
            cell.image = UIImage(named: "placeholder")
            VideoThumbGenerator.generateFrom(url) { [weak self] image in
                if let image = image {
                    self?.collectionViewModel?.setCacheImage(image, key: cacheName)
                    guard cell.representedId == urlString else { return }
                    cell.image = image
                }
            }
        }
        return cell
    }
}

extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension CategoryTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let nodes = collectionViewModel?.nodes {
            delegate?.didSelectNodes(nodes, at: indexPath.row)
        }
    }
}
