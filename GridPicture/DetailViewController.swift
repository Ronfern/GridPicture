//
//  DetailViewController.swift
//  GridPicture
//
//  Created by Роман Чугай on 27.08.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke
class DetailViewController: UIViewController {

    @IBOutlet private weak var fullImage: UIImageView!
    var photoModel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imgURlString = photoModel, let urlImage = URL(string: imgURlString) {
            let request = ImageRequest(
                
                url: urlImage,
                priority: .veryHigh)
            
            let options = ImageLoadingOptions(
                placeholder: UIImage(named: "placeholder"),
                transition: .fadeIn(duration: 0.33)
            )
            
            Nuke.loadImage(with: request, options: options, into: fullImage)
        }
    }
    
    
}
