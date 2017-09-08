//
//  chatCell.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/24/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import UIKit

class chatCell: UICollectionViewCell {
    
    let textView: UITextView = {
     let tv = UITextView()
        tv.text = ""
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor =  .white
        return tv
    }()
    
    static let blue =  UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 1.0)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleW: NSLayoutConstraint?
    var bubbleR: NSLayoutConstraint?
    var bubbleL: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleView)
        addSubview(textView)
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleW = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleW?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor ).isActive = true
        bubbleR = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        bubbleR?.isActive = true
        bubbleL = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        //bubbleL?.isActive = false
        
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor ).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor ).isActive = true
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(codor:) has not been implemented")
    }
}
