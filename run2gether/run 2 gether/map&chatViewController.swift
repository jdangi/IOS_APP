//
//  map&chatViewController.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/18/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import UIKit
import Firebase

class map_chatViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      //  self.navigationController?.navigationBar.shadowImage = UIImage()
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"log out.png"), style: .plain, target: self, action: #selector(handleLogout))
       // if Auth.auth().currentUser?.uid == nil {
        //    performSelector(inBackground: #selector(handleLogout), with: nil)
           // (#selector(handleLogout), with: nil, afterDelay: 0)
       // }
        checkifuserlogin()
    }
    func checkifuserlogin(){
        if Auth.auth().currentUser?.uid == nil {
            performSelector(inBackground: #selector(handleLogout), with: nil)
            
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
               
                if let dictionary = snapshot.value as? [String: Any]{
                    
                    self.navigationItem.title = dictionary["username"] as? String
                }

                })
            
        
        
        }
    
    }
    
    
    @IBAction func logout(_ sender: Any) {
       handleLogout()
    }
    
    func handleLogout(){
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print (logoutError)
        }
        
       Helper.helper.switchToNavigationVC2()

       // let loginControl = loginpageViewController()
      //  present(loginControl, animated: true, completion: nil)
      
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
