//
//  ABImageCaptureViewController.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/6/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit

class ABImageCaptureViewController: UIViewController {
    
    @IBOutlet var capturedImageView: UIImageView!
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        capturedImageView.image = capturedImage
    }
    
}
