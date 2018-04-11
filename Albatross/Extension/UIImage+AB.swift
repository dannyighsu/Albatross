//
//  UIImage+AB.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/8/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func binarizedImage() -> UIImage? {
        let context = CIContext()
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter?.setValue(CIImage(image: self.normalizedRotationImage()), forKey: "inputImage")
        let outputImage = filter?.outputImage
        var binarizedImage: UIImage?
        if let outputImage = outputImage, let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            binarizedImage = UIImage(cgImage: cgimg)
        }
        return binarizedImage
    }
    
    func normalizedRotationImage() -> UIImage {
        if self.imageOrientation == .up { return self }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    func base64String() -> String? {
        let imageData = UIImagePNGRepresentation(self)
        return imageData?.base64EncodedString()
    }
    
}
