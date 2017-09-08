//
//  message.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/22/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

   var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId()-> String? {
    
        if fromId == Auth.auth().currentUser?.uid{
        return toId
        } else{
        return fromId
        }
        
    }
    
    
}
