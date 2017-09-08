//
//  MapViewController.swift
//  run 2 gether
//
//  Created by shahad albalawi on 7/25/17.
//  Copyright © 2017 Shahd Alblu. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var  isInitialized = false;
    @IBOutlet weak var Mapview: MKMapView!
    
    @IBAction func zoomtomylocation(_ sender: Any) {
        
        isInitialized = false
    }
    var users = [User]()
    
      let annotatio = MKPointAnnotation()

    private  var locationM = CLLocationManager()
    private var userlocation: CLLocationCoordinate2D?
    private var friendlocation: CLLocationCoordinate2D?
  //  var pinAnnotationView:MKAnnotationView!
    private var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Mapview.delegate = self

          initlocationManager()
        fetchUser ()
        
       timer  = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(updatefriendLocation), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    private func initlocationManager(){
        locationM.delegate = self
        locationM.desiredAccuracy = kCLLocationAccuracyBest
        locationM.requestWhenInUseAuthorization()
        locationM.startUpdatingLocation()
    }
    
    @objc func updatefriendLocation(){
        //-----friend location----
       
        Mapview.removeAnnotations(Mapview.annotations)
       for i in 0 ..< users.count {

        Database.database().reference().child("Location").child(users[i].uid!).observeSingleEvent(of: .value, with:
            { (snapshot) in
                 if let dictionary = snapshot.value as? [String: Any]{
               self.friendlocation = CLLocationCoordinate2D(latitude: (dictionary["latitude"] as? Double)!, longitude: (dictionary["longitude"] as? Double)!)
                  // print(self.friendlocation)
                    if self.friendlocation != nil {
                        let friendAnnotaion = MKPointAnnotation()
                        friendAnnotaion.coordinate = self.friendlocation!
                        friendAnnotaion.title = self.users[i].username
                       //----------------------------
                        
                      
                        //---------------------------------------

                        self.Mapview.addAnnotation(friendAnnotaion)
                        
                    }
                    
                }
        })
        
        }
    //print(self.friendlocation)
        

         }
    
    //----------------------------
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            //if annotation.title!! == "Me"{
            annotationView!.image = UIImage(named: "pin1")!
           // }else{
            //annotationView!.image = UIImage(named: "pin2")!
          //  }
       // }
            // go ahead and use forced unwrapping and you'll be notified if it can't be found; alternatively, use `guard` statement to accomplish the same thing and show a custom error message
        } else {
           annotationView!.annotation = annotation
      }
        
        return annotationView
    }

 
    //-----------------------------
    func fetchUser (){
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]{
                let user = User()
                user.setValuesForKeys(dictionary)
                
                if user.uid != Auth.auth().currentUser?.uid {
                    self.users.append(user)
                }
            }
            //print(snapshot)
            
        }, withCancel: nil)
        
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location =  locationM.location?.coordinate {
        
            userlocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            

            Mapview.removeAnnotation(annotatio)
          

            annotatio.coordinate = userlocation!
            annotatio.title = "Me"
            Mapview.addAnnotation(annotatio)
          
            if !isInitialized {
                isInitialized = true
            let region = MKCoordinateRegion(center: self.userlocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.Mapview.setRegion(region, animated: true)
            }
          
        
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
