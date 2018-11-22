//
//  ImageViewController.swift
//  PlacticeNet
//
//  Created by 城島一輝 on 2018/11/22.
//  Copyright © 2018 城島一輝. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var tapedImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = tapedImageView?.image
    }
    
    @IBAction func closeViewButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
