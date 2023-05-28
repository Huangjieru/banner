//
//  BannerCollectionViewCell.swift
//  banner
//
//  Created by jr on 2023/5/23.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    //重複使用cell前先清空cell裡的資料
    override func prepareForReuse() {
        bannerImageView.image = nil
    }
    func cellConfigurate(cell:BannerCollectionViewCell){
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.8
        cell.layer.cornerRadius = 20
        cell.bannerImageView.contentMode = .scaleAspectFill
        cell.bannerImageView.clipsToBounds = true
        cell.bannerImageView.layer.cornerRadius = 20
        
    }
}
