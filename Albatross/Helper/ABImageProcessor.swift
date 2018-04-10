//
//  ABImageProcessor.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/6/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit
import Vision

class ABImageProcessor: NSObject {
    
    static func getTextRectangles(_ image: UIImage, completion: @escaping (([VNTextObservation]) -> ())) {
        guard let cgImage = image.cgImage else {
            print("Error creating cgimage.")
            return
        }
        
        let request = VNDetectTextRectanglesRequest { (request, error) in
            guard error == nil else {
                print("Error detecting text rects: \(String(describing: error))")
                return
            }
            
            guard let classifications = request.results?.compactMap({ $0 as? VNTextObservation }) else {
                print("No results for text classification")
                return
            }
            
            completion(classifications)
        }
        request.reportCharacterBoxes = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))!, options: [:])

        do {
            try handler.perform([request])
        } catch {
            /*
             This handler catches general image processing errors. The `classificationRequest`'s
             completion handler `processClassifications(_:error:)` catches errors specific
             to processing that request.
             */
            print("Failed to perform classification.\n\(error.localizedDescription)")
        }
    }
    
}
