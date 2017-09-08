//
//  ViewController.swift
//  run 2 gether
//
//  Created by Shahd Alblu on 10/7/1438 AH.
//  Copyright © 1438 Shahd Alblu. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

   //Map
    @IBOutlet weak var map: MKMapView!
   
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location  = locations[0]
        //how much zoom in to the user location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
          //get the user latitude and longtitude
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
        
        
       
    }
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        manager.delegate = self
        //get the best Accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //requset authorization
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       
        //user is not logged in
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

   override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
    
}

