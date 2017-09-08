//
//  loginpageViewController.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/16/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.

//refrence https://www.letsbuildthatapp.com/


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class loginpageViewController: UIViewController {
 
    @IBOutlet weak var emailtext: UITextField!

    @IBOutlet weak var passwordtext: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser?.uid != nil {
            handleLogout()
        }


    }
    func handleLogout(){
        
        Helper.helper.switchToNavigationVC()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func LoginbuttonTapped(_ sender: Any) {
        
        let Email = emailtext.text
        
        let Password = passwordtext.text
        
        
        
        //check for empty fields
        if((Email?.isEmpty)!||(Password?.isEmpty)!)
        {
            //Disply alert message
            displayAlertMessage( userMessage: " All field are required ");
            return;
            
        }
        
        else{
            Auth.auth().signIn(withEmail: emailtext.text!, password: passwordtext.text! , completion:{ user, error in
                if error != nil{
               self.displayAlertMessage( userMessage: (error?.localizedDescription)! )                
                }else{
                    Helper.helper.switchToNavigationVC()
                }
            } )
        }
    
    
        
       
        
        
        
        //Store data
        
        //Display alert message with confirmation
    
    }
    
    
    func displayAlertMessage(userMessage:String){
        let Alert=UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"ok",style:UIAlertActionStyle.default,handler:nil)
        Alert.addAction(okAction)
        
        self.present(Alert, animated:true,completion:nil)
        
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
