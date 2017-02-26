//
//  PhotoDetailedViewController.swift
//  CatsOnMap
//
//  Created by Nikolay Shubenkov on 26/02/2017.
//  Copyright © 2017 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class PhotoDetailedViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    var photoToShow:PhotoInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = photoToShow.title
        imageView.showImage(with: photoToShow.fullPhoto)
        imageView.contentMode = .scaleAspectFill
        
    }

}
