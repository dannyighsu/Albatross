//
//  ABGoogleVision.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/10/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ABGoogleVision: NSObject {
    
    func textDetectionRequest(image: UIImage) {
        guard let base64String = image.base64String() else {
            print("Error converting image to base 64 string")
            return
        }
        
        
    }
    
}
