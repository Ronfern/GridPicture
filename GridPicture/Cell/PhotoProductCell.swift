//
//  ImageProductCell.swift
//  GridPicture
//
//  Created by Роман Чугай on 26.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke

class PhotoProductCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageCell: UIImageView! {
        didSet {
            imageCell.layer.masksToBounds = false
            imageCell.layer.cornerRadius = 8
            imageCell.clipsToBounds = true
        }
    }
    
    @IBOutlet private weak var viewBack: UIView! {
        didSet{
            viewBack.layer.masksToBounds = false
            viewBack.layer.shadowOffset = CGSize.init(width: 0, height: 0)
            viewBack.layer.shadowColor = UIColor.black.cgColor
            viewBack.layer.shadowRadius = 4.0
            viewBack.layer.shadowOpacity = 0.15
            //
            viewBack.layer.masksToBounds = false
            viewBack.layer.cornerRadius = 16
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        layer.masksToBounds = false
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setPictureToCell(pictureToCell: String?) {
        if let imgURlString = pictureToCell, let urlImage = URL(string: imgURlString) {
            Nuke.loadImage(with: urlImage, into: imageCell)
        }
    }
}


