//
//  HomeCollectionViewCell.swift
//  Unsplash
//
//  Created by alekseienko on 30.10.2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = nil
    }

}
