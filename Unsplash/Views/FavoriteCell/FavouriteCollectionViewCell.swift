//
//  FavouriteCollectionViewCell.swift
//  Unsplash
//
//  Created by alekseienko on 31.10.2022.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainPhoto.layer.cornerRadius = 10
        avatarImg.makeRounded()
        likeImg.image = UIImage(named: "red-like")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainPhoto.image = nil
    }

}
