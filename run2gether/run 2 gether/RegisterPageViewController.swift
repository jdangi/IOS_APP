//
//  RegisterPageViewController.swift
//  run 2 gether
//
//  Created by Shahd Alblu on 10/8/1438 AH.
//  Copyright © 1438 Shahd Alblu. All rights reserved.
//
//refrence https://www.letsbuildthatapp.com/

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit

class RegisterPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var UserConfirmPassText: UITextField!
    @IBOutlet weak var UserPasswordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"background.png")!)
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.png")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailText.text
        
        let userPassword = UserPasswordText.text
        
        let userConfirm = UserConfirmPassText.text
        
        let userName = userNameText.text
        
        
        //check for empty fields
        if((userEmail?.isEmpty)!||(userPassword?.isEmpty)!||(userConfirm?.isEmpty)! || (userName?.isEmpty)!)
        {
            //Disply alert message
            displayAlertMessage( userMessage: " All field are required ");
            
        }else   if (userPassword != userConfirm){
            //Disply alert message
            displayAlertMessage( userMessage: " Passwords do not match ");
            return;
            
        }
        else{
            
     Auth.auth().createUser(withEmail: userEmailText.text!, password: UserPasswordText.text!, completion:
        { user, error in
     if error != nil{
         self.displayAlertMessage( userMessage: (error?.localizedDescription)! )
      
    
    }else{
        let uid = Auth.auth().currentUser?.uid
        let databaseref = Database.database().reference()
        let userData : [String : Any] = ["email":self.userEmailText.text!,"uid": uid!, "username":self.userNameText.text!]
        
        databaseref.child("users").child(uid!).setValue(userData)
        Helper.helper.switchToNavigationVC()
    }
    } )
    }
        //Check if password match
        if (userPassword != userConfirm){
            //Disply alert message
            displayAlertMessage( userMessage: " Passwords do not match ");
            return;
        
        }
        //Store data 
        
        //Display alert message with confirmation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true;
    }

    
    func displayAlertMessage(userMessage:String){
        let Alert=UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"ok",style:UIAlertActionStyle.default,handler:nil)
        Alert.addAction(okAction)
        
        self.present(Alert, animated:true,completion:nil)
        
        }
    private  var locationM = CLLocationManager()
    private var userlocation: CLLocationCoordinate2D?
    
    func inittheuserlocation(){
       
        if let location =  locationM.location?.coordinate {
            
            userlocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
      
            //----------------------------------------
            let ref = Database.database().reference().child("Location")
            let userId = Auth.auth().currentUser?.uid
            if userId != nil{
                let childref = ref.child(userId!)
            
                let values = [ "latitude": location.latitude, "longitude": location.longitude ] as [String : Any];
                
                childref.updateChildValues(values){ (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                }
                
            }
            
            
            
        }
        
    }
    }
        
    

 

