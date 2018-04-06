//
//  ABImageProcessor.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/6/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit

class ABImageProcessor: NSObject {
    
    static func binarize(image: UIImage) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(CIImage(image: image), forKey: "inputImage")
        let outputImage = filter?.outputImage
        var binarizedImage: UIImage?
        if let outputImage = outputImage, let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            binarizedImage = UIImage(cgImage: cgimg)
        }
        return binarizedImage
    }
    
}
