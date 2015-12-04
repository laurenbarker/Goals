//
//  LocationView.swift
//  Goals
//
//  Created by Lauren Barker on 11/16/15.
//  Copyright © 2015 Lauren Barker. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationView: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UITextView!
    
    var locationManager: CLLocationManager!

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
        
    
//    @IBAction func gps_bool(sender: UIButton) {
//        if gps_bool.on {
//            print("Switch is on")
//            gps_bool.setOn(false, animated:true)
//
//        } else {
//            print("Switch is off")
//            gps_bool.setOn(true, animated:true)
//        }
//    }
//    
//    func stateChanged(switchState: UISwitch) {
//        if switchState.on {
//            print("Switch is on")
////            gps_bool.setOn(false, animated:true)
//
//        } else {
//            print("Switch is off")
////            gps_bool.setOn(true, animated:true)
//        }
//    }
    
    
    
    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        gps_bool.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view.
    }
    
    
    

    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        
        
        let location = CLLocation(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print(error)
                return
            }
            
            if placemarks?.count > 0 {
                let pm = placemarks![0]
                
                let addressLines = pm.addressDictionary!["FormattedAddressLines"] as! NSArray
                
                
                self.address.text = addressLines.componentsJoinedByString(", ")
                self.address.numberOfLines = 0
                
                
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    
    func locationManager(manager: CLLocationManager,
        didFailWithError error: NSError){
            print("Location manager failed with error = \(error)")
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            
            
            
    
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                print("Authorized")
            case .AuthorizedWhenInUse:
                print("Authorized when in use")
            case .Denied:
                print("Denied")
            case .NotDetermined:
                print("Not determined")
            case .Restricted:
                print("Restricted")
            }
            
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true;
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.resignFirstResponder()
        super.viewWillDisappear(animated)
        
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
    
    func createLocationManager(startImmediately startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.becomeFirstResponder()
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .AuthorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .Denied:
                /* No */
                displayAlertWithTitle("Not Determined",
                    message: "Location services are not allowed for this app")
            case .NotDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .Restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle("Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    }
    

}
