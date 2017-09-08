//
//  chatlogcontrol.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/21/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import UIKit
import Firebase

class chatlogcontrol: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    
    var user: User?{
        didSet{
            navigationItem.title = user?.username
            
            observeMessages()
            
        }
    }
    var messages = [Message]()

    
    func observeMessages(){
     
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with:
            { (snapshot) in
                let messageId = snapshot.key
                let massegesRef = Database.database().reference().child("messages").child(messageId)
                massegesRef.observe(.value, with:  {
                (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String: Any]
                        else{
                            return
                    }
                    let message = Message()
                   // crash if key dont match
                    message.setValuesForKeys(dictionary)
                    
                    if message.chatPartnerId() ==  self.user?.uid {
                   self.messages.append(message)
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                        })
                    }
                    
                    
                
                })
        } )
    }
    
    
    let inputTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder="Enter massage.."
    textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.white
        
         collectionView?.register(chatCell.self, forCellWithReuseIdentifier: "cellId")
       
     
    
         layoutCells()
         setinputcomponent()
        
        setupKeyboard()
       
    }
    func  setupKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardshow), name: .UIKeyboardWillShow, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(handlekeyboardhide), name: .UIKeyboardWillHide, object: nil)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func handlekeyboardshow(notific: NSNotification){
    let keyboardframe = (notific.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
    let keycoardDuration = (notific.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
      
        containerVB?.constant = -(keyboardframe?.height)!
        
        UIView.animate(withDuration: keycoardDuration!){
        self.view.layoutIfNeeded()
        }
    }
    
    func handlekeyboardhide(notific: NSNotification){
            let keycoardDuration = (notific.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        //  print(keyboardframe?.height)
        containerVB?.constant = 0
        UIView.animate(withDuration: keycoardDuration!){
            self.view.layoutIfNeeded()
        }

    }

    
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
        collectionView!.collectionViewLayout = layout
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        return messages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        
        UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)  as! chatCell
        
            let message = messages[indexPath.item]
            
            cell.textView.text = message.text
            
            if message.fromId == Auth.auth().currentUser?.uid {
                cell.bubbleView.backgroundColor = chatCell.blue
                 cell.textView.textColor = UIColor.white
                
                cell.bubbleR?.isActive = true
                cell.bubbleL?.isActive = false

            }else{
                cell.bubbleView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
                cell.textView.textColor = UIColor.black
                
                cell.bubbleR?.isActive = false
                cell.bubbleL?.isActive = true
            }
                
            cell.bubbleW?.constant =  estframfortext(t: message.text!).width + 32

        
      
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        var height: CGFloat = 80
        
        
        if let t = messages[indexPath.item].text{
        
            height = estframfortext(t: t).height + 20
        }
        
        
        // get the text hight so the bubble fit the hight 
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    private func estframfortext(t: String) -> CGRect{
    let size = CGSize(width: 200, height: 1000)
        let opt = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: t).boundingRect(with: size, options: opt, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerVB: NSLayoutConstraint?
    
    func setinputcomponent(){
     
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
    containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
    containerVB = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    containerVB?.isActive = true
    containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
       sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
         inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorline = UIView()
        separatorline.backgroundColor = UIColor.lightGray
        separatorline.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorline)
        
        separatorline.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorline.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorline.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorline.heightAnchor.constraint(equalToConstant: 1).isActive = true
        

    }
    
    func handleSend(){
    
        let ref = Database.database().reference().child("messages")
        let childref = ref.childByAutoId()
        let timestamp = Int(NSNumber(value: Date().timeIntervalSince1970))
        let fromId = Auth.auth().currentUser?.uid
        let toId = user!.uid!
       if !(inputTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
            let values = ["text":inputTextField.text!, "toId": toId, "fromId": fromId!, "timestamp": timestamp] as [String : Any];
        //childref.updateChildValues(values)
        childref.updateChildValues(values){ (error, ref) in
            if error != nil {
            print(error!)
                return
            }
            }
            //clear input
            
            self.inputTextField.text = nil
            
             let usermassegeRef = Database.database().reference().child("user-messages").child(fromId!)
            
            let messageId = childref.key
            
            usermassegeRef.updateChildValues([messageId: 1])
            
            let recipientUserRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserRef.updateChildValues([messageId: 1])
        }
        
     
    }
}
