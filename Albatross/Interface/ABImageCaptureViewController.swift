//
//  ABImageCaptureViewController.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/6/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Vision

class ABImageCaptureViewController: UIViewController {
    
    @IBOutlet var topBar: UIView!
    @IBOutlet var capturedImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    var capturedImage: UIImage?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .allButUpsideDown
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func okButtonTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 2.0
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        capturedImage = UIImage(named: "card_1_stripped")?.binarizedImage()
        scrollView.contentSize = capturedImage!.size
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        capturedImageView.frame.size = scrollView.contentSize
        capturedImageView.image = capturedImage
        
//        scrollView.zoom(to: capturedImageView.frame, animated: false)
        
        ABImageProcessor.getTextRectangles(capturedImageView.image!) { (result: [VNTextObservation]) in
            for region in result {
                self.highlightWord(box: region)
                
                if let boxes = region.characterBoxes {
                    for characterBox in boxes {
                        self.highlightLetters(box: characterBox)
                    }
                }
            }
        }
    }
    
    private func highlightWord(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {
            return
        }
        
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let xCord = maxX * capturedImageView.frame.size.width
        let yCord = (1 - minY) * capturedImageView.frame.size.height
        let width = (minX - maxX) * capturedImageView.frame.size.width
        let height = (minY - maxY) * capturedImageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        
        capturedImageView.layer.addSublayer(outline)
    }
    
    private func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * capturedImageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * capturedImageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * capturedImageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * capturedImageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        capturedImageView.layer.addSublayer(outline)
    }

}

extension ABImageCaptureViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return capturedImageView
    }
    
}
