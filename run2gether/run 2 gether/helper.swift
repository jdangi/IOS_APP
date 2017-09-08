//
//  helper.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/16/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import Foundation
import UIKit

class Helper {

static let helper = Helper()
    func switchToNavigationVC() {
    
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybord.instantiateViewController(withIdentifier: "profilesVC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    
    }
    func switchToNavigationVC2() {
        
        let storybord1 = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storybord1.instantiateViewController(withIdentifier: "loginpage") as! UINavigationController
        let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
        appDelegate1.window?.rootViewController = vc1
        
    }



}
