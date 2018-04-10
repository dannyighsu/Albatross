//
//  Albatross.swift
//  Albatross
//
//  Created by Daniel Hsu on 4/9/18.
//  Copyright © 2018 Albatross. All rights reserved.
//

import Foundation
import UIKit

class Albatross: NSObject {
    
    static var appDelegate: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
    static var rootViewController: ABRootNavigationController {
        get {
            return appDelegate.window!.rootViewController as! ABRootNavigationController
        }
    }
    
}
